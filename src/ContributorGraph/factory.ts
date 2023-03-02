import { EndorsementGraphCreated } from "../../generated/ContributorGraphFactory/EndorsementGraphFactory"
import { ContributorGraph } from "../../generated/schema"
import { EndorsementGraph } from '../../generated/templates'

export function handleEndorsementGraphCreated(
  event: EndorsementGraphCreated
): void {
    let graph = new ContributorGraph(event.params.graph.toHex())
    graph.name = event.params.name
    graph.symbol = event.params.symbol
    graph.ticket = event.params.ticket.toHex()
    graph.token = event.params.token.toHex()
    graph.save()

    EndorsementGraph.create(event.params.graph)
}