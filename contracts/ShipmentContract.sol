pragma solidity ^0.4.21;

import "./deps/Ownable.sol";
import "./deps/SafeMath.sol";
import "./deps/ERC20Basic.sol";

contract ShipmentContract is Ownable {
    using SafeMath for uint256;

    mapping(uint16 => string) public possibleStates;
    uint16 public numStates;
    uint16 public currentStateIndex;
    string public currentState;
    uint256 public shipmentValue;
    uint256 public weightLbs; 
    uint256 public numPieces; 
    string public poNumber; 
    string public bolNumber;
    uint256 public shipmentId; 
    uint256 public totalCost;

    mapping (uint16 => StateChangeMetadata) public stateChanges;

    address public beneficiary;
    address public tokenAddress;

    // 1.0% FR8 Fee
    uint256 FR8_FEE_PERCENTAGE = 10;
    uint256 FEE_BASIS_POINTS = 1000;
    address FR8_FEE_ADDRESS = 0x11278a8b29109eafe3e41d73a9a94c2e3358caab;

    event StateChanged(string prevString, string currString);

    struct StateChangeMetadata {
        uint256 lon;
        uint256 lat;
        string comment;
    }

    function ShipmentContract(
        uint256 _shipmentValue,
        uint256 _weightLbs,
        uint256 _numPieces,
        string _poNumber,
        string _bolNumber,
        uint256 _shipmentId,
        uint256 _totalCost,
        address _beneficiary,
        address _tokenAddress)
        public {
        numStates = 0;
        currentStateIndex = 0;
        currentState = "DEPLOYED";
        shipmentValue = _shipmentValue;
        weightLbs = _weightLbs;
        numPieces = _numPieces;
        poNumber = _poNumber;
        bolNumber = _bolNumber;
        shipmentId = _shipmentId;
        totalCost = _totalCost;
        beneficiary = _beneficiary;
        tokenAddress = _tokenAddress;
    }

    /**
     * @dev Ensures sure the correct of number of tokens have been deposited to contract
     */
    modifier tokensDeposited() {
        ERC20Basic Token = ERC20Basic(tokenAddress);
        uint256 balance = Token.balanceOf(address(this));
        require (totalCost <= balance);
        _;
    }

    /**
     * @dev Appends _state string to possible states mapping
     */
    function addState(string _state) public onlyOwner {
        possibleStates[numStates] = _state;
        if (numStates == 0) {
            currentState = _state;
        }
        numStates++;
    }

    /**
     * @dev Internal function to settle shipment payment
     */
    function settlePayment() private {
        ERC20Basic Token = ERC20Basic(tokenAddress);
        uint256 balance = Token.balanceOf(address(this));
        uint256 fr8FeeAmount = balance.mul(FR8_FEE_PERCENTAGE).div(FEE_BASIS_POINTS);
        uint256 payout = balance.sub(fr8FeeAmount);
        Token.transfer(beneficiary, payout);
        Token.transfer(FR8_FEE_ADDRESS, fr8FeeAmount);
    }

    /**
     * @dev Internal function to settle shipment payment
     */
    function nextState(uint256 _lon, uint256 _lat, string _comment) public onlyOwner tokensDeposited returns (string shipmentState) {
        // Make sure shipment is not in last state
        require(currentStateIndex < (numStates - 1));

        // Save state change meta data
        stateChanges[currentStateIndex] = StateChangeMetadata(_lon, _lat, _comment);

        // Shift states
        string memory prevState = possibleStates[currentStateIndex];
        currentStateIndex++;
        currentState = possibleStates[currentStateIndex];

        // Settle payment if shipment in last state
        if (currentStateIndex == (numStates - 1)) {
            settlePayment();
        }

        // Emit StateChanged Event
        emit StateChanged(prevState, currentState);
        return shipmentState;
    }
}
