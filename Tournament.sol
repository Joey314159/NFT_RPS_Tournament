//In this file we will create the functions needed to play the game
//Such as randomize values, compare the values, and choose a winner 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract tourney {
    address player1;
    address player2;
    address player3;
    address player4;

    mapping(address => uint) public rolls;
    address[2] public winners;
    //debating which function should be using this, its here in case we need it.
    modifier onlyPlayers() {
        //Addresses involved can only be the players
        require(msg.sender == player1 || msg.sender == player2 || msg.sender == player3 || msg.sender == player4);_;
    }
    //assigning addresses to players
    constructor (address ad1, address ad2, address ad3, address ad4) {
        player1 = ad1;
        player2 = ad2;
        player3 = ad3;
        player4 = ad4;
    }
    //rolls rock(0), paper(1), scissor(2)
    function roll() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 3;
    }
    //logic to determine the winner between 2 addresses
    //ROCK = 0, PAPER = 1, SCISSOR = 2
    function judge(address playerA, address playerB) public returns (address) {
        //shove the roll of playerA and playerB into variables
        uint resA = rolls[playerA];
        uint resB = rolls[playerB];
        /*
            LOGIC:
            Checks playerA's roll and compares it to playerB.
            If playerB and playerA, rolled the same then
            palyerA and playerB reroll and judge function is 
            recursively called.
        */
        if(resA == 0) {
            if(resB == 1) {return playerB;}
            else if (resB == 2) {return playerA;}
            else {
                rolls[playerA] = (roll()+1)%3;
                rolls[playerB] = (roll()+2)%3;
                return judge(playerA, playerB);
            }
        }
        else if(resA == 1) {
            if(resB == 0) {return playerA;}
            else if (resB == 2) {return playerB;}
            else {
                rolls[playerA] = (roll()+1)%3;
                rolls[playerB] = (roll()+2)%3;
                return judge(playerA, playerB);
            }
        }
        else { //resA == 2
            if (resB == 0) {return playerB;}
            else if (resB == 1) {return playerA;}
            else {
                rolls[playerA] = (roll()+1)%3;
                rolls[playerB] = (roll()+2)%3;
                return judge(playerA, playerB);
            }
        }
        

    }
    //starts a game of RPS (Rock, Paper, Scissors)
    function gameStart () public {
        //each player rolls a value from 0-2.
        rolls[player1] = (roll()+1 )% 3;
        rolls[player2] = (roll()+2 )% 3;
        winners[0] = judge(player1,player2); //Bracket 1 winner

        rolls[player3] = (roll()+3 )% 3;
        rolls[player4] = (roll()+4 )% 3;
        winners[1] = judge(player3,player4); //Bracket 2 winner
    }
    //Used as a checking function to see if logic is sound, we can take this out later.
    function getResults(address player) public view returns(uint) { 
        return rolls[player];
    }
}