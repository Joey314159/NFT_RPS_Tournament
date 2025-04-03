//The purpose of this contract is to create the NFT and
//create the functions that we need such as minting the NFT
//burning the NFT, and sending it to an address of our choosing
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

    function mint(string memory nftName) public returns (uint) {
        uint tokenId = ++totalSupply;
        nftList[tokenId] = NFTItem(tokenId, msg.sender, nftName);
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
}
