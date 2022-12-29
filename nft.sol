pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";

// Set the name and symbol for the NFT
string public name = "AF4NFT";
string public symbol = "AF4NFT";

// Use the SafeERC721 and SafeMath libraries
using SafeERC721 for ERC721;
using SafeMath for uint256;

// The contract is owned by an externally owned account
address public owner;

// Mapping from token IDs to token metadata
mapping(uint256 => string) public tokenMetadata;

// Events for transfer and approval
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);

// Initialize the contract with the owner set to the contract creator
constructor() public {
    owner = msg.sender;
}

// Mint a new NFT
function mint(string memory metadata) public payable {
    // Require a payment of 0.1 Ether
    require(msg.value == 100000000000000000, "Incorrect payment amount");

    // Generate a unique token ID
    uint256 id = uint256(keccak256(abi.encodePacked(now, metadata)));

    // Set the token metadata
    tokenMetadata[id] = metadata;

    // Transfer the NFT to the msg.sender
    ERC721.safeTransferFrom(address(0), msg.sender, id);
    emit Transfer(address(0), msg.sender, id);

    // Send the Ether to the contract owner
    owner.transfer(msg.value);
}

// Transfer an NFT from one address to another
function transfer(address to, uint256 id) public {
    // Ensure the msg.sender owns the NFT
    ERC721.safeTransferFrom(msg.sender, to, id);
    emit Transfer(msg.sender, to, id);
}

// Allow another address to spend a certain amount of tokens on behalf of the owner
function approve(address spender, uint256 id) public {
    // Ensure the msg.sender owns the NFT
    ERC721.safeApprove(msg.sender, spender, id);
    emit Approval(msg.sender, spender, id);
}

// Transfer an NFT on behalf of the owner
function transferFrom(address from, address to, uint256 id) public {
    // Ensure the from address has approved the msg.sender to transfer the NFT
    ERC721.safeTransferFrom(from, to, id, msg.sender);
    emit Transfer(from, to, id);
}

// Get the metadata for a token ID
function getTokenMetadata(uint256 id) public view returns (string memory) {
    return tokenMetadata[id];
}
