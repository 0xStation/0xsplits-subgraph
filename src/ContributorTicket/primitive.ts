import { Address, BigInt, log } from "@graphprotocol/graph-ts"
import { Transfer } from "../../generated/templates/ContributorTicket/ContributorTicket"
import { ContributorDirectory, ContributorTicket } from "../../generated/schema"
import { zeroAddress } from "../constants"

function ticketId(address: Address, tokenId: BigInt): string {
  return `${address.toHex()}::ticket:${tokenId.toString()}`
}
  
export function handleContributorTicketTransfer(
    event: Transfer
  ): void {
    if (event.params.from.toHex() == zeroAddress) {
      // new ticket is minted
      let directory = ContributorDirectory.load(event.address.toHex())
      if (!directory) {
        log.info('No corresponding directory found for ticket with address: {}', [event.address.toHex()])
        return
      }

      let ticket = new ContributorTicket(ticketId(event.address, event.params.tokenId))
      ticket.directory = directory.id
      ticket.owner = event.params.to.toHex()
      ticket.tokenId = event.params.tokenId.toI32()
      ticket.mintedAt = event.block.timestamp.toI32()
      ticket.save()
    } else {
      // existing ticket changing owners
      let ticket = ContributorTicket.load(ticketId(event.address, event.params.tokenId))
      if (!ticket) {
        log.info('No corresponding ticket found address: {} and tokenId: {}', [event.address.toHex(), event.params.tokenId.toString()])
        return
      }

      ticket.owner = event.params.to.toHex()
      ticket.save()
    }
  }