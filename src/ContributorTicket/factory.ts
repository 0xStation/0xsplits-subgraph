import { ContributorTicketCreated } from "../../generated/ContributorTicketFactory/ContributorTicketFactory"
import { ContributorDirectory } from "../../generated/schema"
import { ContributorTicket } from '../../generated/templates'

export function handleContributorTicketCreated(
  event: ContributorTicketCreated
): void {
    let directory = new ContributorDirectory(event.params.ticket.toHex())
    directory.name = event.params.name
    directory.symbol = event.params.symbol
    directory.save()

    ContributorTicket.create(event.params.ticket)
}