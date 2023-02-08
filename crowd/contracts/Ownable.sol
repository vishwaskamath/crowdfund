// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Ownable {
    // Variable that maintains
    // manager address
    address private _manager;

    // Sets the original manager of
    // contract when it is deployed
    constructor() {
        _manager = msg.sender;
    }

    // Publicly exposes who is the
    // manager of this contract
    function manager() public view returns (address) {
        return _manager;
    }

    // onlymanager modifier that validates only
    // if caller of function is contract manager,
    // otherwise not
    modifier onlyManager() {
        require(isManager(), "Function accessible only by the manager !!");
        _;
    }

    // function for managers to verify their managership.
    // Returns true for managers otherwise false
    function isManager() public view returns (bool) {
        return msg.sender == _manager;
    }
}
