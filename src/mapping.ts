import { Address, BigInt, ethereum, log } from "@graphprotocol/graph-ts";
import {
  CreateSplit,
  CreateSplitCall,
  DistributeERC20,
  DistributeETH,
  Withdrawal,
} from "../generated/SplitMain/SplitMain";
import {
  Recipient,
  SplitRecipient,
  Split,
  SplitRecipientToken,
  SplitRecipientWithdrawEvent,
} from "../generated/schema";

const PERCENTAGE_SCALE = 1_000_000;
const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const WITHDRAWAL_EVENT_PREFIX = "we";
const ID_SEPARATOR = ":";

function joinIds(ids: string[]): string {
  return ids.join(ID_SEPARATOR);
}

function expandId(id: string): string[] {
  return id.split(ID_SEPARATOR);
}

// reimplementation of internal function within SplitMain
// https://github.com/0xSplits/splits-contracts/blob/main/contracts/SplitMain.sol#L808
function _scaleAmountByPercentage(
  amount: BigInt,
  scaledPercent: BigInt
): BigInt {
  return amount.times(scaledPercent).div(BigInt.fromI64(PERCENTAGE_SCALE));
}

export function handleCreateSplit(event: CreateSplit): void {
  const splitId = event.params.split.toHex();
  let split = Split.load(splitId);
  if (!split) {
    split = new Split(splitId);
    split.recipients = [];
    split.save();
  }
}

export function handleCreateSplitCall(call: CreateSplitCall): void {
  const splitId = call.outputs.split.toHex();
  let split = Split.load(splitId);
  if (!split) {
    split = new Split(splitId);
  }
  split.distributorFee = call.inputs.distributorFee;

  let recipients = call.inputs.accounts;
  let allocations = call.inputs.percentAllocations;
  let splitRecipientIds = new Array<string>();

  for (let i: i32 = 0; i < recipients.length; i++) {
    let recipientId = recipients[i].toHex();
    let splitRecipientId = joinIds([splitId, recipientId]);

    let recipient = Recipient.load(recipientId);
    if (!recipient) {
      recipient = new Recipient(recipientId);
      recipient.splits = [];
    }
    let recipientSplits = recipient.splits;
    recipientSplits.push(splitRecipientId);

    recipient.splits = recipientSplits;
    recipient.save();

    let splitRecipient = new SplitRecipient(splitRecipientId);
    splitRecipient.split = splitId;
    splitRecipient.recipient = recipientId;
    splitRecipient.allocation = allocations[i];
    splitRecipient.save();
    splitRecipientIds.push(splitRecipientId);
  }

  split.recipients = splitRecipientIds;
  split.save();
}

export function handleDistributeETH(event: DistributeETH): void {
  handleDistribution(
    event.params.split.toHex(),
    event.params.amount,
    ZERO_ADDRESS
  );
}

export function handleDistributeERC20(event: DistributeERC20): void {
  handleDistribution(
    event.params.split.toHex(),
    event.params.amount,
    event.params.token.toHex()
  );
}

// shared helper for DistributeETH and DistributeERC20
function handleDistribution(
  splitAddress: string,
  amount: BigInt,
  tokenAddress: string
): void {
  let split = Split.load(splitAddress);
  if (!split) {
    log.warning("handleDistributeETH, no split found: " + splitAddress, []);
    return;
  }
  let amountToSplit = amount;

  const distributorFeeAmount = _scaleAmountByPercentage(
    amountToSplit,
    split.distributorFee
  );
  amountToSplit = amountToSplit.minus(distributorFeeAmount);

  const splitRecipientIds = split.recipients;
  for (let i: i32 = 0; i < splitRecipientIds.length; i++) {
    let splitRecipient = SplitRecipient.load(splitRecipientIds[i]);
    if (!splitRecipient) {
      log.warning(
        "handleDistributeETH, missing splitRecipient: " + splitRecipientIds[i],
        []
      );
      return;
    }

    const splitRecipientTokenId = joinIds([splitRecipient.id, tokenAddress]);
    let splitRecipientToken = SplitRecipientToken.load(splitRecipientTokenId);
    if (!splitRecipientToken) {
      splitRecipientToken = new SplitRecipientToken(splitRecipientTokenId);
      splitRecipientToken.splitRecipient = splitRecipient.id;
      splitRecipientToken.tokenAddress = tokenAddress;
      splitRecipientToken.totalDistributed = BigInt.fromI32(0);
      splitRecipientToken.totalClaimed = BigInt.fromI32(0);
    }

    splitRecipientToken.totalDistributed = splitRecipientToken.totalDistributed.plus(
      _scaleAmountByPercentage(amountToSplit, splitRecipient.allocation)
    );

    splitRecipientToken.save();
  }
}

// TODO: add split-withdraw events table for history tab
// TODO: handle split updates
export function handleWithdrawal(event: Withdrawal): void {
  const recipientId = event.params.account.toHex();
  let recipient = Recipient.load(recipientId);
  if (!recipient) {
    log.warning("handleWithdrawal, missing recipient: " + recipientId, []);
    return;
  }

  let tokens =
    event.params.tokens.map<string>((address) => address.toHex()) || [];
  if (event.params.ethAmount.gt(BigInt.fromI32(0))) {
    tokens.push(ZERO_ADDRESS);
  }

  const splitRecipientIds = recipient.splits;
  for (let i: i32 = 0; i < splitRecipientIds.length; i++) {
    for (let j: i32 = 0; j < tokens.length; j++) {
      const splitRecipientTokenId = joinIds([splitRecipientIds[i], tokens[j]]);
      let splitRecipientToken = SplitRecipientToken.load(splitRecipientTokenId);

      // if this split has not made a distribution with this token, skip
      if (!splitRecipientToken) {
        continue;
      }

      const lastDistributed = splitRecipientToken.totalDistributed;
      const lastClaimed = splitRecipientToken.totalClaimed;
      const valueWithdrawn = lastDistributed.minus(lastClaimed);

      // if this split is not responsible for any distribution, skip
      // prevents adding event to history in case of no value withdrawn
      // also reduces load to reduce risk of not saving event entries
      if (valueWithdrawn.equals(BigInt.fromI32(0))) {
        continue;
      }

      splitRecipientToken.totalClaimed = lastDistributed;
      splitRecipientToken.save();

      // save withdraw event for history view

      let txHash = event.transaction.hash.toHexString();
      let logIdx = event.logIndex.toString();
      let withdrawalEventId = joinIds([
        WITHDRAWAL_EVENT_PREFIX,
        txHash,
        logIdx,
        recipientId,
      ]);

      const expandedId = expandId(splitRecipientIds[i]);
      const splitId = expandedId[0];

      let withdrawEvent = new SplitRecipientWithdrawEvent(withdrawalEventId);
      withdrawEvent.split = splitId;
      withdrawEvent.recipient = recipientId;
      withdrawEvent.tokenAddress = tokens[j];
      withdrawEvent.value = valueWithdrawn;
      withdrawEvent.timestamp = event.block.timestamp;
      withdrawEvent.transactionHash = txHash;
      withdrawEvent.save();
    }
  }
}
