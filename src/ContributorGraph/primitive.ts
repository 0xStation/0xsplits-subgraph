import { Address, BigInt, log } from "@graphprotocol/graph-ts"
import { Endorsed } from "../../generated/templates/EndorsementGraph/EndorsementGraph"
import { ContributorGraph, ContributorRelationship, ContributorEndorsement, TerminalInitiative } from "../../generated/schema"

function relationshipId(address: Address, from: BigInt, to: BigInt): string {
  return `${address.toHex()}::relationship:${from.toString()}->${to.toString()}`
}

function endorsementId(relationship: string, count: number): string {
    return `${relationship}::endorsement:${count.toString()}`
}

function initiativeId(directory: string, localId: BigInt): string {
  return `${directory}::initiative:${localId.toString()}`
}

export function handleEndorsementGraphEndorsed(
    event: Endorsed
  ): void {
    let graph = ContributorGraph.load(event.address.toHex())
    if (!graph) {
        log.info('No corresponding graph found for endorsement from address: {}', [event.address.toHex()])
        return
    }

    // update/create relationship

    const rId = relationshipId(event.address, event.params.from, event.params.to)
    let relationship = ContributorRelationship.load(rId)
    if (relationship) {
        relationship.total = relationship.total.plus(event.params.amount)
        relationship.endorsementCount = relationship.endorsementCount + 1
    } else {
        relationship = new ContributorRelationship(rId)
        relationship.graph = graph.id
        relationship.from = event.params.from.toI32()
        relationship.to = event.params.to.toI32()
        relationship.total = BigInt.zero()
        relationship.endorsementCount = 1
    }
    relationship.save()

    // update/create initiative

    const iId = initiativeId(event.address.toHex(), event.params.graph)
    let initiative = TerminalInitiative.load(iId)
    if (initiative) {
      initiative.endorsementCount = initiative.endorsementCount + 1
    } else {
      initiative = new TerminalInitiative(iId)
      initiative.localId = event.params.graph
      initiative.endorsementCount = 1
    }
    initiative.save()

    // create endorsement

    let endorsement = new ContributorEndorsement(endorsementId(rId, relationship.endorsementCount))
    endorsement.relationship = relationship.id
    endorsement.initiative = initiative.id
    endorsement.timestamp = event.block.timestamp.toI32()
    endorsement.amount = event.params.amount.toI32()
    endorsement.save()
  }