import { Address, BigInt, log } from "@graphprotocol/graph-ts";
import {
  CreateSplit,
  CreateSplitCall,
  DistributeETH,
  Withdrawal,
} from "../generated/SplitMain/SplitMain";
import { Recipient, SplitRecipient, Split } from "../generated/schema";

const PERCENTAGE_SCALE = 1_000_000;

function genSplitId(proxyAddress: Address): string {
  return proxyAddress.toHex();
}

function joinIds(ids: string[]): string {
  return ids.join(":");
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
  log.warning("handleCreateSplit", []);
  const splitId = genSplitId(event.params.split);
  let split = Split.load(splitId);
  if (!split) {
    log.warning("handleCreateSplit: split does not yet exist", []);
    split = new Split(splitId);
    split.recipients = [];
    split.save();
  }
}

export function handleCreateSplitCall(call: CreateSplitCall): void {
  log.warning("handleCreateSplitCall", []);
  const splitId = genSplitId(call.outputs.split);
  let split = Split.load(splitId);
  if (!split) {
    log.warning("handleCreateSplitCall: split does not yet exist", []);
    split = new Split(splitId);
  }
  split.distributorFee = call.inputs.distributorFee;
  split.totalEthDistributed = BigInt.fromI32(0);
  split.totalEthClaimed = BigInt.fromI32(0);

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
      recipient.totalEthClaimed = BigInt.fromI32(0);
    }
    let recipientSplits = recipient.splits;
    recipientSplits.push(splitRecipientId);

    recipient.splits = recipientSplits;
    recipient.save();

    let splitRecipient = new SplitRecipient(splitRecipientId);
    splitRecipient.split = splitId;
    splitRecipient.recipient = recipientId;
    splitRecipient.allocation = allocations[i];
    splitRecipient.totalEthDistributed = BigInt.fromI32(0);
    splitRecipient.totalEthClaimed = BigInt.fromI32(0);
    splitRecipient.save();
    splitRecipientIds.push(splitRecipientId);
  }

  split.recipients = splitRecipientIds;
  split.save();
}

export function handleDistributeETH(event: DistributeETH): void {
  let split = Split.load(genSplitId(event.params.split));
  if (!split) {
    log.warning(
      "handleDistributeETH, no split found: " + genSplitId(event.params.split),
      []
    );
    return;
  }
  let amountToSplit = event.params.amount;
  split.totalEthDistributed = split.totalEthDistributed.plus(amountToSplit);
  split.save();

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
    splitRecipient.totalEthDistributed = splitRecipient.totalEthDistributed.plus(
      _scaleAmountByPercentage(amountToSplit, splitRecipient.allocation)
    );
    splitRecipient.save();
  }
}

// TODO: add split-withdraw events table for history tab
// TODO: handle split updates
// TODO: handle ERC20s
export function handleWithdrawal(event: Withdrawal): void {
  const recipientId = event.params.account.toHex();
  let recipient = Recipient.load(recipientId);
  if (!recipient) {
    log.warning("handleWithdrawal, missing recipient: " + recipientId, []);
    return;
  }

  const splitRecipientIds = recipient.splits;
  for (let i: i32 = 0; i < splitRecipientIds.length; i++) {
    let splitRecipient = SplitRecipient.load(splitRecipientIds[i]);
    if (!splitRecipient) {
      log.warning(
        "handleWithdrawal, missing splitRecipient: " + splitRecipientIds[i],
        []
      );
      return;
    }
    let split = Split.load(splitRecipient.split);
    if (!split) {
      log.warning(
        "handleWithdrawal, missing split: " + splitRecipient.split,
        []
      );
      return;
    }

    const splitEthClaimed = splitRecipient.totalEthDistributed.minus(
      splitRecipient.totalEthClaimed
    );

    splitRecipient.totalEthClaimed = splitRecipient.totalEthDistributed;
    splitRecipient.save();

    split.totalEthClaimed = split.totalEthClaimed.plus(splitEthClaimed);
    split.save();
  }
}
