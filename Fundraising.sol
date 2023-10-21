// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Fundraising {
    
    address public manager;
    uint public balance;
    uint public targetAmount;
    mapping(address => bool) public donors;
    uint public totalDonors;
    bool public targetAmountAchieved;

    constructor(uint _targetAmount) {
        manager = msg.sender;
        targetAmount = _targetAmount;
    }

    modifier onlyManager() {
        require(msg.sender == manager);
        _;
    }

    modifier donationsOpen() {
        require (!targetAmountAchieved, "Donations are closed since the target amount for the campaing has been achieved!");
        _;
    }

    modifier donationsClosed() {
        require(targetAmountAchieved, "You will be able to withdrow once the targetAmount has been achieved");
        _;
    }

    function donate() external payable donationsOpen {
        require(msg.value > 0, "Donations must be greater than 0!");
        balance += msg.value;

        if(!donors[msg.sender]) {
            donors[msg.sender] = true;
            totalDonors ++;
        }

        if(balance >= targetAmount) {
            targetAmountAchieved = true;
        }
    }

    function withdraw(uint amount) external onlyManager donationsClosed {
        require(amount <= balance, "You are trying to withdraw more than balance");
        balance -= amount;
        payable(manager).transfer(amount);
    }

    function compareTargetToBalance() external view returns (bool) {
        return targetAmountAchieved;
    }

}