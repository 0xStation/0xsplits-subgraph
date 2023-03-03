import { Address, BigInt, log } from "@graphprotocol/graph-ts";
import {
  CreateSplit,
  CreateSplitCall,
  DistributeETH,
} from "../generated/SplitMain/SplitMain";
import { Member, Split } from "../generated/schema";

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
    split.members = [];
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

  let accounts = call.inputs.accounts;
  let allocations = call.inputs.percentAllocations;
  let memberIds = new Array<string>();

  for (let i: i32 = 0; i < accounts.length; i++) {
    let accountId = accounts[i].toHex();
    let memberId = joinIds([splitId, accountId]);

    log.warning("handleCreateSplitCall: member pre-create", [memberId]);
    let member = new Member(memberId);
    member.split = splitId;
    member.recipient = accountId;
    member.allocation = allocations[i];
    member.totalEthDistributed = BigInt.fromI32(0);
    member.save();
    memberIds.push(memberId);
    log.warning("handleCreateSplitCall: member saved", [memberId]);
  }

  split.members = memberIds;
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

  const memberIds = split.members;
  for (let i: i32 = 0; i < memberIds.length; i++) {
    let member = Member.load(memberIds[i]);
    if (!member) {
      log.warning("handleDistributeETH, missing member: " + memberIds[i], []);
      return;
    }
    member.totalEthDistributed = member.totalEthDistributed.plus(
      _scaleAmountByPercentage(amountToSplit, member.allocation)
    );
    member.save();
  }
}
