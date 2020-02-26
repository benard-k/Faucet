// Version of Solidity compiler this program was written for
pragma solidity >=0.4.22 <0.7.0;
contract owned {
    address payable owner;
    // Contract constructor: set owner
    constructor() public {
        owner = msg.sender;
    }

    // Access control modifier
    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function."
        );
        _;
    }
}

contract  mortal is owned {
    // Destroy contract
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}

// Our first contract is a faucet!
contract Faucet is mortal {
    // events for withdrawals and deposits
    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);

    // Accept any incoming amount
    function () external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Give out ether to anyone who asks
    function withdraw(uint withdraw_amount) public {
        // Limit withdrawal amount
        require(withdraw_amount <= 100000000000000000);
        // Check that that there is enough ether
        require(address(this).balance >= withdraw_amount, "Insufficient balance in faucet for withdrawal");
        // Send the amount to the address that requested it
        msg.sender.transfer(withdraw_amount);
        emit Withdrawal(msg.sender, withdraw_amount);
    }
}

contract  Token is mortal {
    Faucet _faucet;

    constructor() public {
        _faucet = new Faucet();
    }
}