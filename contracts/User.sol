//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";


/**
*@title UserRegister
*@dev This contract registers new user with a referrar address and stores their details with basic token transfer functionalities.
 */

contract UserRegister {


    Token public token;

   
    constructor(Token _token) public {
        token = _token;
    }
  
    struct profile  {
        address myAddress;
        address referralCode;
        uint registration_time;
      
       

    }

    mapping(address => profile) public user;

    /**
     *@dev Registers user and Token is transferred as registartion fees.
     * Requirements:
     * - the caller must have a balance of at least 100.
     * - should not be a registered user.0
     *@param _referralCode represents the address of the user's referrer.
     *Note: This function will register user by paying 100 tokens
     *Already registered users cant avail this function.
     */

    function register (address _referralCode) public {
        require(user[msg.sender].myAddress==address(0),"User already registered");
     
        token.approve(address(this), 100);
        token.transferFrom(msg.sender, address(this), 100);
        
        user[msg.sender].myAddress=msg.sender;
        user[msg.sender].referralCode= _referralCode;
        user[msg.sender].registration_time= block.timestamp;

        console.log("Registration time is :",user[msg.sender].registration_time);
        console.log("User Account Balance :",token.balanceOf(msg.sender));
        console.log("Contract Balance :",token.balanceOf(address(this)));

        // emit Registered(msg.sender, _referralCode, block.timestamp);

    }

}