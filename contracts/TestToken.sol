pragma solidity ^0.4.15;

import './deps/MintableToken.sol';
import './deps/ERC20Interface.sol';
import './deps/Ownable.sol';
import './deps/ApproveAndCallFallBack.sol';


contract TestToken is ERC20Interface, Ownable {
  using SafeMath for uint;

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

  // ------------------------------------------------------------------------
  // Constructor
  // ------------------------------------------------------------------------
  function TestToken() public {
    version = 3;

    // initial erc20 settings
    symbol = "TST";
    name = "Test Token";
    decimals = 18;
    mintable = true;

    _totalSupply = 1000000000 * 10**uint(decimals);

    balances[owner] = _totalSupply;
    Transfer(address(0), owner, _totalSupply);
  }

  // ------------------------------------------------------------------------
  // Total supply
  // ------------------------------------------------------------------------
  function totalSupply() public view returns (uint) {
    return _totalSupply - balances[address(0)];
  }

  // ------------------------------------------------------------------------
  // Disable minting
  // ------------------------------------------------------------------------
  function disableMinting() public onlyOwner {
    require(mintable);
    mintable = false;
    MintingDisabled();
  }

  // ------------------------------------------------------------------------
  // Get the token balance for account `tokenOwner`
  // ------------------------------------------------------------------------
  function balanceOf(address tokenOwner) public view returns (uint balance) {
    return balances[tokenOwner];
  }

  // ------------------------------------------------------------------------
  // Transfer the balance from token owner's account to `to` account
  // - Owner's account must have sufficient balance to transfer
  // - 0 value transfers are allowed
  // ------------------------------------------------------------------------
  function transfer(address to, uint tokens) public returns (bool success) {
    balances[msg.sender] = balances[msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    Transfer(msg.sender, to, tokens);
    return true;
  }

  // ------------------------------------------------------------------------
  // Token owner can approve for `spender` to transferFrom(...) `tokens`
  // from the token owner's account
  //
  // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
  // recommends that there are no checks for the approval double-spend attack
  // as this should be implemented in user interfaces 
  // ------------------------------------------------------------------------
  function approve(address spender, uint tokens) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    Approval(msg.sender, spender, tokens);
    return true;
  }

  // ------------------------------------------------------------------------
  // Transfer `tokens` from the `from` account to the `to` account
  // 
  // The calling account must already have sufficient tokens approve(...)-d
  // for spending from the `from` account and
  // - From account must have sufficient balance to transfer
  // - Spender must have sufficient allowance to transfer
  // - 0 value transfers are allowed
  // ------------------------------------------------------------------------
  function transferFrom(address from, address to, uint tokens) public returns (bool success) {
    balances[from] = balances[from].sub(tokens);
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    Transfer(from, to, tokens);
    return true;
  }

  // ------------------------------------------------------------------------
  // Returns the amount of tokens approved by the owner that can be
  // transferred to the spender's account
  // ------------------------------------------------------------------------
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    return allowed[tokenOwner][spender];
  }

  // ------------------------------------------------------------------------
  // Token owner can approve for `spender` to transferFrom(...) `tokens`
  // from the token owner's account. The `spender` contract function
  // `receiveApproval(...)` is then executed
  // ------------------------------------------------------------------------
  function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    Approval(msg.sender, spender, tokens);
    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
    return true;
  }

  // ------------------------------------------------------------------------
  // Mint tokens
  // ------------------------------------------------------------------------
  function mint(address tokenOwner, uint tokens) public onlyOwner returns (bool success) {
    require(mintable);
    balances[tokenOwner] = balances[tokenOwner].add(tokens);
    _totalSupply = _totalSupply.add(tokens);
    Transfer(address(0), tokenOwner, tokens);
    return true;
  }

  // ------------------------------------------------------------------------
  // Owner can transfer out any accidentally sent ERC20 tokens
  // ------------------------------------------------------------------------
  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
    return ERC20Interface(tokenAddress).transfer(owner, tokens);
  }
}
