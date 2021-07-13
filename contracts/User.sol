//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/utils/math/SafeMath.sol';


/**
*@title UserRegister
*@dev This contract registers new user with a referrar address and stores their details with basic token transfer functionalities.
 */

contract UserRegister is Ownable {


    Token public token;

    using SafeMath for uint256;

   
    constructor(Token _token) public {
        token = _token;
    }
  
    struct profile  {
        address myAddress;
        address referralCode;
        uint registration_time;
        uint256 score;
        uint256 rewards;
      
       

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
    }

    /**
     *@dev Rewards are given to  the user according to the score set ny the owner
      *Requirements:
      * - the caller should be the owner.
      * - the  user address should be registered already
      *@param userAddress_ represents the address of the user.
      *@param score_ represnts the score to be given to the specific user.
      *Note : This function will store rewards obtained by the user with the given address by the owner.
      *Only the owner of the contract can avail this function.
      */

    function setScore (address userAddress_,uint256 score_) public onlyOwner {
            

        user[userAddress_].score = score_;
        uint256 reward = (score_.mul(20)).div(1000);
        uint256 _reward = user[userAddress_].rewards;
        user[userAddress_].rewards = reward.add(_reward);

        console.log("Reward obtained by",userAddress_,"is",reward);
        console.log("Total reward :",user[userAddress_].rewards);
    }

}