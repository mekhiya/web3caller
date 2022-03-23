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
    uint256 public numOfDeposits;
    uint256 public numOfUniqueDepositors;
    uint256 public totalVaultValue;
    uint256 public totalDepositValue;
    uint256 public numberOfWatch;
    //0.00091 ETH watcher fees
    //911000000000000 WEI
    uint256 public watchCreationFees = 911000000000000;
    //0.000091 Alert amount (1/10th of watchCreationFees)
    //91100000000000 WEI
    //uint256 public alertAmount = watchCreationFees / 10;

    //uint256 maturityTimePostRedemption = 9 days;
    uint256 maturityTimePostRedemption = 120 seconds;

    struct Deposit {
        uint256 depositId;
        address depositorAddress;
        uint256 amount;
        uint256 creationTime;
        uint256 maturityTime;
    }

    mapping(address => Deposit[]) ownerOfDeposits;

    struct Watch {
        address depositorAddress;
        address watcherAddress;
        uint256 watchCreationTime;
    }

    //creationTime => Watch
    mapping(uint256 => Watch[]) depositToWatches;

    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function getVaultDetails()
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (
            numOfDeposits,
            numOfUniqueDepositors,
            totalDepositValue,
            numberOfWatch
        );
    }

    //0.00091 ETH watcher fees
    //911000000000000 WEI
    //Example : amount = 0.1 eth
    //total = 0.10091 ETH
    // total 100911000000000000 wei
    //FRONTEND UI automatically adds 0.00091 ETH watcher fees to deposit amount
    function addDeposit() public payable {
        //function will be called by depositor
        //amount sent will be 'deposit amount' + 0.00911

        uint256 _depositId = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender))
        );

        uint256 _amount = msg.value;
        address _funderAddress = msg.sender;

        ownerOfDeposits[_funderAddress].push(
            Deposit(
                _depositId,
                _funderAddress,
                _amount,
                block.timestamp,
                block.timestamp
            )
        );
        //if length is 1, it means this is a new depositor
        if (ownerOfDeposits[_funderAddress].length == 1) {
            // this is a new Depositor, creating deposit for the first time
            numOfUniqueDepositors++;
        }
        numOfDeposits++;
        totalDepositValue += _amount;
        totalVaultValue += _amount;

        //adds watcher for Deposit creator (watch for depositor himself)
        depositToWatches[_depositId].push(
            Watch(msg.sender, msg.sender, block.timestamp)
        );
        numberOfWatch++;
    }

    //adds watcher for anyone on any deposit by charging 0.00091 ETH (911000000000000 wei)
    function addWatcher(uint256 _depositId, address _depositorAddress)
        public
        payable
    {
        //msg.value >= 911000000000000
        require(
            msg.value >= watchCreationFees,
            "0.00091 ETH required to create Watch"
        );

        (bool depositExists, , ) = getDepositIndex(
            _depositId,
            _depositorAddress
        );
        require(depositExists, "No Deposits exists for address!");

        depositToWatches[_depositId].push(
            Watch(_depositorAddress, msg.sender, block.timestamp)
        );
        numberOfWatch = numberOfWatch + 1;
        totalVaultValue = totalVaultValue + msg.value;
    }

    //finds depositIndex
    // Result only for msg.Sender
    // returns true if deposit exists, index position, numOfDepositsByUser
    function getDepositIndex(uint256 _depositId, address _depositorAddress)
        public
        view
        returns (
            bool,
            uint256,
            uint256
        )
    {
        uint256 numOfDepositsByUser = ownerOfDeposits[_depositorAddress].length;
        for (uint256 index = 0; index < numOfDepositsByUser; index++) {
            if (
                ownerOfDeposits[_depositorAddress][index].depositId ==
                _depositId
            ) {
                return (true, index, numOfDepositsByUser);
            }
        }
        //fix this, looks incorrect
        return (false, 0, numOfDepositsByUser);
    }

    function submitWithdrawRequest(uint256 _depositId) public {
        // ???? moves tx details to withdraw list with time required

        (bool depositFound, uint256 _depositIndex, ) = getDepositIndex(
            _depositId,
            msg.sender
        );
        require(depositFound, "Deposit not found!");
        //Below require is redundant but still important to keep check
        require(
            ownerOfDeposits[msg.sender][_depositIndex].depositorAddress ==
                msg.sender,
            "Not authorised!"
        );
        require(
            ownerOfDeposits[msg.sender][_depositIndex].creationTime ==
                ownerOfDeposits[msg.sender][_depositIndex].maturityTime,
            "Deposit withdraw already submitted!"
        );

        uint256 newMaturityTime = block.timestamp + maturityTimePostRedemption;
        ownerOfDeposits[msg.sender][_depositIndex]
            .maturityTime = newMaturityTime;

        alertWatchers(
            false,
            ownerOfDeposits[msg.sender][_depositIndex].depositId
        );
    }

    function withdraw(uint256 _depositId) public {
        (
            bool depositFound,
            uint256 _depositIndex,
            uint256 _numOfDepositsByUser
        ) = getDepositIndex(_depositId, msg.sender);
        require(depositFound, "Deposit not found!");
        //Below require is redundant but still important to keep check
        require(
            ownerOfDeposits[msg.sender][_depositIndex].depositorAddress ==
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
        uint256 _amountToTransfer = ownerOfDeposits[msg.sender][_depositIndex]
            .amount;
        payable(msg.sender).transfer(_amountToTransfer);

        Deposit memory removeDeposit;
        removeDeposit = ownerOfDeposits[msg.sender][_depositIndex];
        ownerOfDeposits[msg.sender][_depositIndex] = ownerOfDeposits[
            msg.sender
        ][_numOfDepositsByUser - 1];
        ownerOfDeposits[msg.sender][_numOfDepositsByUser - 1] = removeDeposit;
        ownerOfDeposits[msg.sender].pop();

        // PENDING
        // check for minimum 10 dollars deposit

        numOfDeposits--;
        totalDepositValue -= _amountToTransfer;
        totalVaultValue -= _amountToTransfer;

        alertWatchers(true, removeDeposit.depositId);
    }

    function alertWatchers(bool _isFinalAlert, uint256 _depositId) public {
        //to all deposits for deposiId send alert.
        //if _isFinalAlert, remove watch[] for same & udpate numOfWatchs
        uint256 numOfWatchsForDepositId = depositToWatches[_depositId].length;

        if (depositToWatches[_depositId].length > 0) {
            for (uint256 index = 0; index < numOfWatchsForDepositId; index++) {
                uint256 lastIndex = numOfWatchsForDepositId - index - 1;
                address _watcherAddress = depositToWatches[_depositId][
                    lastIndex
                ].watcherAddress;

                payable(_watcherAddress).transfer(watchCreationFees / 10);
                if (_isFinalAlert) {
                    //we delete watch when alert sent during Withdraw method & not submitwithdraw method
                    depositToWatches[_depositId].pop();
                    numberOfWatch--;
                }
            }
        }
    }

    function getDepositsByOwner(address _depositorAddress)
        public
        view
        returns (Deposit[] memory)
    {
        return ownerOfDeposits[_depositorAddress];
    }

    function getWatchesOnDeposit(uint256 _depositId)
        public
        view
        returns (Watch[] memory)
    {
        return depositToWatches[_depositId];
    }
}
