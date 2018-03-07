pragma solidity ^0.4.15;

import './deps/StandardToken.sol';
import './deps/Ownable.sol';

contract TestToken is StandardToken, Ownable {
    string public constant name = "TestToken";
    string public constant symbol = "TST";
    uint8 public constant decimals = 18;
    bool public mintingFinished = false;
    bool public transferEnabled = false;
    address public saleAddress;


    function allocateToSale()
      onlyOwner
      public
    {
      /* 80% of total supply goes to sale */
      uint saleSupply = totalSupply.div(100).mul(80);
      balances[saleAddress] = balances[saleAddress].add(saleSupply);
      Transfer(address(0), saleAddress, saleSupply);
    }

    function allocateToTeam(address _teamAddress)
      onlyOwner
      public
    {
      /* 20% of total supply goes to team */
      uint teamSupply = totalSupply.div(100).mul(20);
      balances[_teamAddress] = balances[_teamAddress].add(teamSupply);
      Transfer(address(0), _teamAddress, teamSupply);
    }

    // @dev allows the token owner to award tokens directly to an address
    function awardTokens(address _to, uint _amount)
      onlyOwner
      public
    {
      balances[_to] = balances[_to].add(_amount);
      Transfer(address(0), _to, _amount);
    }

   
}
