
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Main {
    NFT public nft;
    tourney public tourneyContract;

    //Creating an event to send out a message to the winner
    event tourneyWinner(address indexed winner, string message);

    address finalWinner;
    address [] players;

    //Collecting the addresses of the players
    constructor(address Alice) {
        //Creating instances of the smart contracts
        address Bob = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        address Charlie = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
        address Danny = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
        nft = new NFT();
        tourneyContract = new tourney(Alice, Bob, Charlie, Danny);

        players.push(Alice);
        players.push(Bob);
        players.push(Charlie);
        players.push(Danny);

    }

    function run() public {
        tourneyContract.gameStart();

        //Holds the winner of the first game
        address winner1 = tourneyContract.winners(0);
        //Holds the winner of the second game
        address winner2 = tourneyContract.winners(1);

        //Last game is the winner of the 2 previous winners
        finalWinner = tourneyContract.judge(winner1, winner2);

        //Minting the NFT in order to give it to the winner
        uint tokenID = nft.mint("Rock Paper Scissors Champ", finalWinner);

        //Displaying a message to congragulate them
        emit tourneyWinner(finalWinner, "Congrtualtions, you're the winner");
        
        //Lastly give them the NFT Token
        nft.transferFrom(address(this), finalWinner, tokenID);

    }

    function getWinner() public view returns (address) {
        return finalWinner;
    }
    function getPlayers() public view returns (address [] memory){
        return players;
    }
    function getNFTOwner(uint256 tokenId) public view returns (address) {
        return nft.getOwner(tokenId);
    }
}

contract NFT {
    uint public totalSupply;
    string public name = "RPST";
    string public symbol = "TOKEN";

    struct NFTItem {
        uint id;
        address owner;
        string name;
    }

    //Matches each token ID to the token item
    mapping(uint256 => NFTItem) public nftList;
    //Keeps track of how many NFTs each address has
    mapping(address => uint256) public balanceOf;
    //Matches the token ID to the owner of that NFT
    mapping(uint256 => address) private nftToOwner;
    //Single-token approvals
    mapping(uint256 => address) private tokenApprovals; 

    //Events that we need in order to make this work
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event Burn(uint indexed id, string name, address indexed owner);

    function ownerOf(uint256 tokenId) public view returns (address) {
        return nftToOwner[tokenId];
    }

    function mint(string memory nftName, address reciever) public returns (uint) {
        uint tokenId = ++totalSupply;
        nftList[tokenId] = NFTItem(tokenId, reciever, nftName);
        nftToOwner[tokenId] = msg.sender;
        balanceOf[msg.sender]++;

        emit Transfer(address(0), msg.sender, tokenId);
        return tokenId;
    }

    function approve(address to, uint256 tokenId) public {
        require(msg.sender == nftToOwner[tokenId], "Not the owner");
        tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        return tokenApprovals[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(nftToOwner[tokenId] == from, "Not the owner");
        require(to != address(0), "Invalid address");
        require(msg.sender == from || getApproved(tokenId) == msg.sender, "Not authorized"); // Only single-token approvals

        //Clear approvals
        delete tokenApprovals[tokenId];

        //Transfer ownership by first giving the token to the user
        nftToOwner[tokenId] = to;
        //Than making them the owner
        nftList[tokenId].owner = to;
        //Lastly we reduce our balance
        balanceOf[from]--;
        //And increase their's
        balanceOf[to]++;

        //Calling the Transfer event
        emit Transfer(from, to, tokenId);
    }

    function burn(uint256 tokenId) public {
        require(nftToOwner[tokenId] == msg.sender, "You are not the owner of this NFT");

        //Retrieve the name before deletion
        string memory nftName = nftList[tokenId].name; 

        //Remove ownership
        delete nftToOwner[tokenId];  
        balanceOf[msg.sender]--;

        //Reduce total supply
        totalSupply--;

        //Emit burn event with the correct name
        emit Burn(tokenId, nftName, msg.sender);

        //Remove from the nftList mapping
        delete nftList[tokenId]; 
    }

    function getOwner(uint256 tokenId) public view returns (address) {
        return nftToOwner[tokenId];
    }
}

contract tourney {
    address player1;
    address player2;
    address player3;
    address player4;

    mapping(address => uint) public rolls;
    address[2] public winners;

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
    function roll( ) public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp))) % 3;
    }
    function judge(address playerA, address playerB) public returns (address) {
        //ROCK = 0, PAPER = 1, SCISSOR = 2
        uint resA = rolls[playerA];
        uint resB = rolls[playerB];

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
        //assigns a roll to each 
        rolls[player1] = (roll()+1)% 3;
        rolls[player2] = (roll()+2)% 3;
        winners[0] = judge(player1,player2);

        rolls[player3] = (roll()+3)% 3;
        rolls[player4] = (roll()+4 )% 3;
        winners[1] = judge(player3,player4);
    }

    function getResults(address player) public view returns(uint) {
        return rolls[player];
    }

}