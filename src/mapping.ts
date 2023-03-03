import { Address } from "@graphprotocol/graph-ts";
import { CreateSplit } from "../generated/SplitMain/SplitMain";
import { Split } from "../generated/schema";

function genSplitId(proxyAddress: Address): string {
  return proxyAddress.toHex();
}

function genAccountId(address: Address): string {
  return address.toHex();
}

function genMemberId(splitId: string, accountId: Address): string {
  return `${splitId}:${accountId}`;
}

export function handleCreateSplit(event: CreateSplit): void {
  const splitId = genSplitId(event.params.split);
  let split = Split.load(splitId);
  if (!split) {
    split = new Split(splitId);
    split.save();
  }
}
