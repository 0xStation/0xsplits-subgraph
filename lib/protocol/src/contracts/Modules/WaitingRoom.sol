// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IConfigurableFungibleTokenFull as ICFT} from "solkit/FungibleToken/Interfaces.sol";
import {ContractOwner} from "solkit/Mixins/ContractOwner.sol";

import {IReferrals} from "../Referrals/IReferrals.sol";

contract WaitingRoom is ContractOwner {
    event Endorse(address indexed referrals, address indexed sender, address indexed recipient, uint256 endorsementsAmount, uint256 pointsAmount, uint256 initiative);
    event EndorseCostOverride(address indexed referrals, uint256 cost);
    event EndorseCostReset(address indexed referrals);

    mapping(address => uint256) internal costs;

    function overrideCost(address referrals, uint256 amount) external onlyOwnerOf(referrals) {
        costs[referrals] = amount;
        if (amount > 0) {
            emit EndorseCostOverride(referrals, amount);
        } else {
            emit EndorseCostReset(referrals);
        }
    }

    function getCost(address referrals) external view returns (uint256) {
        if (costs[referrals] > 0) {
            return costs[referrals];
        } else {
            // default minimum is 1 endorsements unit
            return 10 ** ICFT(IReferrals(referrals).endorsementsToken()).decimals();
        }
    }

    function _getCost(address referrals, ICFT endorsements) internal view returns (uint256) {
        if (costs[referrals] > 0) {
            return costs[referrals];
        } else {
            // default minimum is 1 endorsements unit
            return 10 ** endorsements.decimals();
        }
    }

    function endorse(address referrals, address recipient, uint256 amount, uint256 initiative) external returns (uint256) {
        ICFT endorsements = ICFT(IReferrals(referrals).endorsementsToken());
        require(amount >= _getCost(referrals, endorsements), "WaitingRoom: Under minimum endorsement cost");

        ICFT points = ICFT(IReferrals(referrals).pointsToken());
        // force referrals to be an allowed contract for the points it is pointing to
        // this prevents anyone from just making a referrals that is connected to a points contract
        require(points.isAllowedContract(referrals), "WaitingRoom: Referrals is not allowed to mint points");

        endorsements.transferFrom(msg.sender, referrals, amount);
        IReferrals(referrals).endorseFrom(msg.sender, recipient, amount);
        // in the future, add actual math to make up for potential decimals difference
        // for ship speed, we are assuming Endorsements and Points are both using the same decimals value
        points.mintTo(recipient, amount);

        emit Endorse(referrals, msg.sender, recipient, amount, amount, initiative);
        return amount;
    }
}