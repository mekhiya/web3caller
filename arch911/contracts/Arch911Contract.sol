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
    function getDepositIndex(address _funderAddress, uint256 _tx)
        public
        view
        returns (bool, uint256)
    {
        //Deposit memory deposit;
        uint256 numOfDeposits = getDepositCounts(_funderAddress);
        for (uint256 index = 0; index < numOfDeposits; index++) {
            if (ownerOfDeposits[_funderAddress][index].txNumber == _tx) {
                return (true, index);
            }
        }
        //fix this, looks incorrect
        return (false, 0);
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

        (bool depositFound, uint256 _depositIndex) = getDepositIndex(
            msg.sender,
            _tx
        );
        require(depositFound, "Deposit not found!");
        //Below require is redundant but still important to keep check
        require(
            ownerOfDeposits[msg.sender][_depositIndex].funderAddress ==
                msg.sender,
            "Not authorised!"
        );
        require(
            ownerOfDeposits[msg.sender][_depositIndex].creationTime ==
                ownerOfDeposits[msg.sender][_depositIndex].maturityTime,
            "Deposit withdraw already submitted!"
        );

        uint256 newMaturityTime = block.timestamp +
            (numberOfDaysForMaturity * 1 days);
        ownerOfDeposits[msg.sender][_depositIndex]
            .maturityTime = newMaturityTime;
    }

    function withdraw(uint256 _tx) public {
        (bool depositFound, uint256 _depositIndex) = getDepositIndex(
            msg.sender,
            _tx
        );
        require(depositFound, "Deposit not found!");
        //Below require is redundant but still important to keep check
        require(
            ownerOfDeposits[msg.sender][_depositIndex].funderAddress ==
                msg.sender,
            "Not authorised!"
        );
        require(
            ownerOfDeposits[msg.sender][_depositIndex].creationTime !=
                ownerOfDeposits[msg.sender][_depositIndex].maturityTime,
            "Deposit withdraw request not submitted!"
        );
        require(
            block.timestamp >=
                ownerOfDeposits[msg.sender][_depositIndex].maturityTime,
            "Deposit withdraw maturity not achieved yet!"
        );
        uint256 amountToTransfer = ownerOfDeposits[msg.sender][_depositIndex]
            .amount;
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
