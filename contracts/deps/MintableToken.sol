pragma solidity ^0.4.18;
import './StandardToken.sol';
import './Ownable.sol';

/** Create contract that extends the standard ERC20 token contract with minting capabilities.
 *  We've provided you with the pseudocode and some hints to guide you in the right direction.
 *  Some of the initial conditions are written out for you to ease you into writing the contracts.
 *  Make sure to implement the best practices you learned during the Solidity Walkthrough segment.
 *  Check for errors by compiling often. Ask your classmates for help - we highly encourage student collaboration.
 */
// Set up your contract so that it inherits functionality from OpenZeppelin's StandardToken and Ownable.
contract MintableToken is StandardToken, Ownable {
    // Create event that logs the receiver address and the amount of the token being minted.
    event Mint(address indexed to, uint256 amount);
    // Create event that logs the completion of token minting.
    event MintFinished();
   
    // Set the initial state to reflect that minting is not finished.
    bool public mintingFinished = false;
    // Create modifier that enforces the condition for minting to be available only if minting is not finished.
    modifier canMint() {
        // Require statements are used to check for conditions and throw an exception if the condition isn't met.
        require(!mintingFinished);
        // _; is used to return the flow of execution to the original function.
        _;
    }
    // Create function to mint tokens with 2 parameters: the address that will receive the minted tokens and the amount of tokens to mint.
    // Write the function so that it returns a boolean that indicates if the operation was successful.
    // Make sure to include the appropriate modifers.
    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
        // Update the state of total token supply by adding the amount of tokens minted.
        totalSupply = totalSupply.add(_amount);
        // Update the state of the receiving address's token balance by adding the amount of tokens minted.
        balances[_to] = balances[_to].add(_amount);
        // Emit the Mint event with appropriate input parameters.
        Mint(_to, _amount);
        // Execute the Transfer function inherited from the StandardToken contract to deliver the minted tokens to the receiver.
        // Transfer function requires 3 parameters: address tokens are coming from, address tokens are going to, amount of tokens.        
        Transfer(address(0), _to, _amount);
        // Indicate that the operation was successful. 
        return true;
    }
    // Create function to stop minting new tokens. Modifiers modifiers modifiers.
    // Write the function so taht it returns a boolean that indicates if the operation was successful.
    function finishMinting() onlyOwner canMint public returns (bool) {
        // Update initial state to reflect that minting is finished.
        mintingFinished = true;
        // Emit event that logs the completion of token minting.
        MintFinished();
        // Indicate that the operation was successful.
        return true;
    }
}