import { Address, BigInt } from "@graphprotocol/graph-ts"
import { Endorse } from "../generated/WaitingRoom/WaitingRoom"
import { WaitingRoomInitiative, InitiativeApplicant, ApplicantReferral } from "../generated/schema"

function initiativeId(referralGraph: Address, localId: BigInt): string {
  return `${referralGraph.toHex()}:${localId.toString()}`
}

function applicantId(initiativeId: string, address: Address): string {
  return `${initiativeId}:${address.toHex()}`
}

function referralId(applicantId: string, referrer: Address): string {
    return `${applicantId}:${referrer.toHex()}`
}

export function handleEndorse(
    event: Endorse
  ): void {
    const iId = initiativeId(event.params.referrals, event.params.initiative)
    let initiative = WaitingRoomInitiative.load(iId)
    if (!initiative) {
      // create initiative    
      initiative = new WaitingRoomInitiative(iId)
      initiative.referralGraph = event.params.referrals.toHex()
      initiative.localId = event.params.initiative
      initiative.save()
    }

    let aId = applicantId(iId, event.params.recipient)
    let applicant = InitiativeApplicant.load(aId)
    if (!applicant) {
      // create applicant
      applicant = new InitiativeApplicant(aId)
      applicant.initiative = initiative.id
      applicant.address = event.params.recipient.toHex()
      applicant.points = event.params.pointsAmount
    } else {
      // update applicant points
      applicant.points = applicant.points.plus(event.params.pointsAmount)
    }
    applicant.save()

    let rId = referralId(aId, event.params.sender)
    let referral = ApplicantReferral.load(rId)
    if (!referral) {
      // create referral
      referral = new ApplicantReferral(rId)
      referral.applicant = applicant.id
      referral.from = event.params.sender.toHex()
      referral.amount = event.params.endorsementsAmount
    } else {
      // update referral amount
      referral.amount = referral.amount.plus(event.params.endorsementsAmount)
    }
    referral.save()
  }