// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Arch911Contract is Ownable {
    // depositFund() - internally calls create watcher
    // createWatcher()
    // submitWithdrawRequest() - moves tx details to withdraw list with time required
    // maturityTime = now + (numberOfDays * 1 days);

    // ????? ApproveWithdraw() onlyOwner
    // withDraw() - depositor can come back again & withdraw to same address/account
    // alertWatchers() onlyOwner - sent to all watchers. sent 2nd to deposiot when period over
    // get911Status() called twice daily from external method/contract/ui

    //function depositFund()

    address[] public depositors;
    address[] public watchers;
    uint256 numberOfDaysForMaturity = 9;

    struct Deposit {
        uint256 txNumber;
        address funderAddress;
        uint256 amount;
        uint256 creationTime;
        uint256 maturityTime;
    }

    mapping(address => Deposit[]) ownerOfDeposits;

    struct Watcher {
        uint256 txNumber;
        address watcherAddress;
        uint256 creationTime;
    }

    mapping(uint256 => Watcher[]) txToWatchers;

    function addDeposit() public payable {
        //function will be called by depositor
        //amount sent will be amount + 0.00911

        //create depositor entry
        //create watcher entry

        uint256 _amount = msg.value;
        address _funderAddress = msg.sender;
        uint256 _tx = uint256(1); // get tx number of money transfer hwo to get tx in advance.
        //if tx not available, use generate randomnumber+timestamp

        ownerOfDeposits[_funderAddress].push(
            Deposit(
                _tx,
                _funderAddress,
                _amount,
                block.timestamp,
                block.timestamp
            )
        );

        depositors.push(_funderAddress); // is this required????
        //addressToDepositTx[_funderAddress] = _tx;
    }

    //adds watcher for transations
    function addWatcher(uint256 _tx, address _watcherAddress) public {
        txToWatchers[_tx].push(Watcher(_tx, _watcherAddress, block.timestamp));
        watchers.push(_watcherAddress); // is this required????
    }

    //finds deposit
    function getDepositDetails(address _funderAddress, uint256 _tx)
        public
        returns (Deposit memory, uint256)
    {
        Deposit memory deposit;
        uint256 numOfDeposits = getDepositCounts(_funderAddress);
        for (uint256 index = 0; index < numOfDeposits; index++) {
            //deposit = ownerOfDeposits(_funderAddress, index);
            deposit = ownerOfDeposits[_funderAddress][index];
            if (deposit.txNumber == _tx) {
                return (deposit, index);
            }
        }
        //fix this, looks incorrect
        uint256 number = 1234;
        return (deposit, number);
    }

    //this will help in finding all deposits created by address
    function getDepositCounts(address _funderAddress)
        public
        view
        returns (uint256)
    {
        return ownerOfDeposits[_funderAddress].length;
    }

    function submitWithdrawRequest(uint256 _tx) public {
        // ???? moves tx details to withdraw list with time required
        // maturityTime = now + (numberOfDays * 1 days);

        //instead get index number in deposit[] and then use
        //something like (address)(index) to dierectly work on block data
        (Deposit memory deposit, uint256 _index) = getDepositDetails(
            msg.sender,
            _tx
        );
        //Below require is redundant but still important to keep check
        require(deposit.funderAddress == msg.sender, "Not authorised!");
        require(
            deposit.creationTime == deposit.maturityTime,
            "Deposit withdraw already submitted!"
        );

        // ??? does this write/change value in block ??? or is in memory

        // deposit.maturityTime =
        //     block.timestamp +
        //     (numberOfDaysForMaturity * 1 days);

        // ownerOfDeposits(msg.sender, _index).maturityTime =
        //     block.timestamp +
        //     (numberOfDaysForMaturity * 1 days);
    }

    function withdraw(uint256 _tx) public {
        (Deposit memory deposit, uint256 _index) = getDepositDetails(
            msg.sender,
            _tx
        );
        //Below require is redundant but still important to keep check
        require(deposit.funderAddress == msg.sender, "Not authorised!");
        require(
            deposit.creationTime != deposit.maturityTime,
            "Deposit withdraw request not submitted!"
        );
        require(
            block.timestamp >= deposit.maturityTime,
            "Deposit withdraw maturity not achieved yet!"
        );
        uint256 amountToTransfer = deposit.amount;
        payable(msg.sender).transfer(amountToTransfer);

        // payable(msg.sender).transfer(etherBalanceOf[msg.sender])

        //is this right way to wipe???

        //ownerOfDeposits(msg.sender, _index) = new Deposit();

        // PENDING
        // check for minimum 10 dollars deposit
        //sender all watchers 0.000912
        //clean all mappings for funders & watchers
    }
}
