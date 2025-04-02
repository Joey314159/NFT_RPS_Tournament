// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Burn(uint indexed id, string name, address indexed owner);

    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract NFT is IERC721 {
    uint public totalSupply;
    string public name = "RPST";
    string public symbol = "TOKEN";

    struct NFTItem {
        uint id;
        address owner;
        string name;
    }

    mapping(uint256 => NFTItem) public nftList;
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => address) private nftToOwner;
    mapping(uint256 => address) private tokenApprovals;
    mapping(address => mapping(address => bool)) private operatorApprovals;

    function ownerOf(uint256 tokenId) public view override returns (address) {
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

    function approve(address to, uint256 tokenId) public override {
        require(msg.sender == nftToOwner[tokenId], "Not the owner");
        tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view override returns (address) {
        return tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public override {
        operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(nftToOwner[tokenId] == from, "Not the owner");
        require(to != address(0), "Invalid address");
        require(msg.sender == from || getApproved(tokenId) == msg.sender || isApprovedForAll(from, msg.sender), "Not authorized");

        // Clear approvals
        delete tokenApprovals[tokenId];

        // Transfer ownership
        nftToOwner[tokenId] = to;
        nftList[tokenId].owner = to;
        balanceOf[from]--;
        balanceOf[to]++;

        emit Transfer(from, to, tokenId);
    }

    function burn(uint256 tokenId) public {
        require(nftToOwner[tokenId] == msg.sender, "You are not the owner of this NFT");

        string memory nftName = nftList[tokenId].name; // Retrieve the name before deletion

        // Remove ownership
        delete nftToOwner[tokenId];  
        balanceOf[msg.sender]--;

        // Reduce total supply
        totalSupply--;

        // Emit burn event with the correct name
        emit Burn(tokenId, nftName, msg.sender);

        // Remove from the nftList mapping
        delete nftList[tokenId]; 
    }

}