pragma solidity ^0.6.0;

import "./ERC20.sol";


contract CDP {
    
    using SafeMath for uint256;
    address private _token_address;
    ERC20 public token;
    
    
    struct Loan {
        uint Collateral; // locked ETH
        uint Withdrawn; // withdrawn XAI
    }

    mapping (address => Loan) public _pool;

    address _manager;

    
    constructor (ERC20 token_address) public {
        _manager = msg.sender;
        _token_address = address(token_address);
        token = token_address;
    }

    function mint() public payable{
        // uint current_usd_price = getETHUSDPrice();
        token.TransferFrom(_token_address, msg.sender, msg.value);
        Loan storage l = _pool[msg.sender];
        l.Collateral += msg.value;
        l.Withdrawn += msg.value;
    }
    
    
    function redeem(uint256 amount) public {
        // uint current_usd_price = getETHUSDPrice();
        Loan storage l = _pool[msg.sender];
        l.Collateral -= amount;
        l.Withdrawn -= amount;
    }
    
    function getETHUSDPrice() public view returns (uint) {
        address ethUsdPriceFeed = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
        return uint(
        IMakerPriceFeed(ethUsdPriceFeed).read()
        );
    }
    
    
}


interface IMakerPriceFeed {
  function read() external view returns (bytes32);
}