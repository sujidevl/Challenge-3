// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenContract {
    string public tokenName;
    string public tokenSymbol;
    uint256 public tokenTotalSupply;
    mapping(address => uint256) public accountBalance;
    address public contractOwner;

    event TransferEvent(address indexed from, address indexed to, uint256 amount);
    event BurnEvent(address indexed from, uint256 amount);
    event MintEvent(address indexed to, uint256 amount);

    constructor(string memory _tokenName, string memory _tokenSymbol) {
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        tokenTotalSupply = 0;
        contractOwner = msg.sender;
    }

    modifier onlyContractOwner() {
        require(
            msg.sender == contractOwner,
            "Only the contract owner can perform this action"
        );
        _;
    }

    function mintTokens(address to, uint256 amount) public onlyContractOwner {
        accountBalance[to] += amount;
        tokenTotalSupply += amount;
        emit MintEvent(to, amount);
        emit TransferEvent(address(0), to, amount);
    }

    function burnTokens(uint256 amount) public {
        require(accountBalance[msg.sender] >= amount, "Insufficient balance");

        accountBalance[msg.sender] -= amount;
        tokenTotalSupply -= amount;
        emit BurnEvent(msg.sender, amount);
        emit TransferEvent(msg.sender, address(0), amount);
    }

    function transferTokens(address to, uint256 amount) public {
        require(accountBalance[msg.sender] >= amount, "Insufficient balance");

        accountBalance[msg.sender] -= amount;
        accountBalance[to] += amount;
        emit TransferEvent(msg.sender, to, amount);
    }
}
