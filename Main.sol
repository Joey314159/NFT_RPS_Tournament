//In this file we will actually play the game
//Creating instances of the classes/contracts we need in order to play it
//In this class we will create the players and gift the token to the winner
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Importing this in order to 
import "NFT.sol";
import "Tournament.sol";

contract Main {
    NFT public nft;
    tourney public tourneyContract;

    //Creating an event to send out a message to the winner
    event tourneyWinner(address indexed winner, string message);

    //Collecting the addresses of the players
    constructor(address Alice, address Bob, address Charlie, address Danny) {
        //Creating instances of the smart contracts
        nft = new NFT();
        tourneyContract = new tourney(Alice, Bob, Charlie, Danny);
    }

    //Starting the tournamnet
    function startTourney() public {
        tourneyContract.gameStart();
    }

    function RewardForWinner() public {
        //Holds the winner of the first game
        address winner1 = tourneyContract.winners(0);
        //Holds the winner of the second game
        address winner2 = tourneyContract.winners(1);

        //Last game is the winner of the 2 previous winners
        address finalWinner = tourneyContract.judge(winner1, winner2);

        //Minting the NFT in order to give it to the winner
        uint tokenID = nft.mint("Rock Paper Scissors Champ");

        //Displaying a message to congragulate them
        emit tourneyWinner(finalWinner, "Congrtualtions, you're the winner");
        
        //Lastly give them the NFT Token
        nft.transferFrom(address(this), finalWinner, tokenID);
    }
}