pragma solidity ^0.4.18;

import './deps/MintableToken.sol';
import './deps/ERC20Interface.sol';
import './deps/Ownable.sol';
import './deps/ApproveAndCallFallBack.sol';


contract Fr8NetworkToken is ERC20Interface, Ownable {
  using SafeMath for uint256;

  // standard ERC20 stuff
  string public symbol;
  string public  name;
  uint8 public decimals;
  uint public _totalSupply;
  bool public mintable;

  // contract version
  uint public version;

  mapping(address => uint) internal balances;
  mapping(address => mapping(address => uint)) internal allowed;


  event MintingDisabled();

  function Fr8NetworkToken() public {
    version = 10;

    // initial erc20 settings
    symbol = "FR8";
    name = "Fr8 Network Test Token";
    decimals = 18;
    mintable = true;

    _totalSupply = 1000000000 * 10**uint(decimals);

    balances[owner] = _totalSupply;
    Transfer(address(0), owner, _totalSupply);
  }

  function totalSupply() public view returns (uint) {
    return _totalSupply - balances[address(0)];
  }

  function disableMinting() public onlyOwner {
    require(mintable);
    mintable = false;
    MintingDisabled();
  }

  function balanceOf(address tokenOwner) public view returns (uint balance) {
    return balances[tokenOwner];
  }

  function transfer(address to, uint tokens) public returns (bool success) {
    balances[msg.sender] = balances[msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    Transfer(msg.sender, to, tokens);
    return true;
  }

  /**
   * Token owner can approve for `spender` to transferFrom(...) `tokens`
   * from the token owner's account
   *
   * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
   * recommends that there are no checks for the approval double-spend attack
   * as this should be implemented in user interfaces 
   */
  function approve(address spender, uint tokens) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    Approval(msg.sender, spender, tokens);
    return true;
  }

  /**
   * Transfer `tokens` from the `from` account to the `to` account
   *
   * The calling account must already have sufficient tokens approve(...)-d
   * for spending from the `from` account and
   * - From account must have sufficient balance to transfer
   * - Spender must have sufficient allowance to transfer
   * - 0 value transfers are allowed
   */
  function transferFrom(address from, address to, uint tokens) public returns (bool success) {
    balances[from] = balances[from].sub(tokens);
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    Transfer(from, to, tokens);
    return true;
  }

  /**
   * Returns the amount of tokens approved by the owner that can be
   * transferred to the spender's account
   */
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    return allowed[tokenOwner][spender];
  }

  /**
   * Token owner can approve for `spender` to transferFrom(...) `tokens`
   * from the token owner's account. The `spender` contract function 
   * `receiveApproval(...)` is then executed
  */
  function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    Approval(msg.sender, spender, tokens);
    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
    return true;
  }


  /**
   * Mint tokens
   */
  function mint(address tokenOwner, uint tokens) public onlyOwner returns (bool success) {
    require(mintable);
    balances[tokenOwner] = balances[tokenOwner].add(tokens);
    _totalSupply = _totalSupply.add(tokens);
    Transfer(address(0), tokenOwner, tokens);
    return true;
  }

  /**
   * [Deprecated] Owner can transfer out any accidentally sent ERC20 tokens
   * Ensure cannot send self token
   */
  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
    return ERC20Interface(tokenAddress).transfer(owner, tokens);
  }
}
