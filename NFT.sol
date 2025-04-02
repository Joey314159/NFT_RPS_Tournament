// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Burn(uint indexed _id, string name, address indexed owner);

    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
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
    mapping(address => mapping(address => bool)) private _operatorApprovals;

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

    function setApprovalForAll(address operator, bool _approved) public override {
        _operatorApprovals[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }

    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return _operatorApprovals[owner][operator];
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

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public override {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "Receiver not implemented");
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private returns (bool) {
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch {
                revert("Receiver contract not implemented");
            }
        }
        return true;
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