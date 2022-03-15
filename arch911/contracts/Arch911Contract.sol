// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Arch911Contract {
    // depositFund() - internally calls create watcher
    // createWatcher()
    // submitWithdrawRequest()
    // ApproveWithdraw() onlyOwner
    // alertWatchers() onlyOwner
    // get911Status() called twice daily from external method/contract/ui
}
