import { Address, log } from "@graphprotocol/graph-ts";
import { CreateSplit, CreateSplitCall } from "../generated/SplitMain/SplitMain";
import { Member, Split } from "../generated/schema";

function genSplitId(proxyAddress: Address): string {
  return proxyAddress.toHex();
}

function joinIds(ids: string[]): string {
  return ids.join(":");
}

export function handleCreateSplit(event: CreateSplit): void {
  log.warning("handleCreateSplit", []);
  const splitId = genSplitId(event.params.split);
  let split = Split.load(splitId);
  if (!split) {
    log.warning("handleCreateSplit: split does not yet exist", []);
    split = new Split(splitId);
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
    split.save();
  }

  let accounts = call.inputs.accounts;
  let allocations = call.inputs.percentAllocations;

  for (let i: i32 = 0; i < accounts.length; i++) {
    let accountId = accounts[i].toHex();
    let memberId = joinIds([splitId, accountId]);

    log.warning("handleCreateSplitCall: member pre-create", [memberId]);
    let member = new Member(memberId);
    member.split = splitId;
    member.recipient = accountId;
    member.allocation = allocations[i];
    member.save();
    log.warning("handleCreateSplitCall: member saved", [memberId]);
  }
}
