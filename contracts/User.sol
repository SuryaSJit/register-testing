//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";

contract UserRegister {


    Token public token;

    constructor(Token _token) public {
        token = _token;
    }
    // event Registered(
    //     address account,
    //     address referral_code,
    //     uint registered_time
    // );

    struct profile  {
        address myAddress;
        address referralCode;
        uint registration_time;
      
       

    }

    mapping(address => profile) public user;

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