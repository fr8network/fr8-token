pragma solidity ^0.4.18;

import './deps/Ownable.sol';
import './deps/SafeMath.sol';
import '../node_modules/zeppelin-solidity/contracts/token//ERC20/ERC20Basic.sol';
import '../node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';

contract ShipmentContract is Ownable {
  using SafeMath for uint;

  mapping(uint256 => string) possibleStates;
  address beneficiary;
  uint256 numStates;
  uint256 currentStateIndex;
  string public currentState;
  uint256 shipmentValue;
  uint256 weightLbs; 
  uint256 numPieces; 
  string poNumber; 
  uint256 shipmentId; 
  uint256 totalCost;

  event ChangeStatus(string prevString, string currString);

  /**
  Deploy args: all uint256
  
  3500,12000,6,18504502,49504020,400
  */

  function settlePayments(uint256 amount) private {
    ERC20 token = ERC20(0x8049F53D94eCf5D1e669f80977eecf075B461608);
    token.transfer(beneficiary, amount*10^18);
  }

  function ShipmentContract(uint256 _shipmentValue, uint256 _weightLbs, uint256 _numPieces, string _poNumber, uint256 _shipmentId, uint256 _totalCost, address _beneficiary) {
    numStates = 5;
    possibleStates[0] = "SHIPMENT_BOOKED";
    possibleStates[1] = "CARRIER_ASSIGNED";
    possibleStates[2] = "EN_ROUTE_TO_DESTINATION";
    possibleStates[3] = "ARRIVED_AT_DESTINATION";
    possibleStates[4] = "SHIPMENT_DELIVERED";

    currentStateIndex = 0;
    currentState = possibleStates[currentStateIndex];
    shipmentValue = _shipmentValue;
    weightLbs = _weightLbs; 
    numPieces = _numPieces; 
    poNumber = _poNumber; 
    shipmentId = _shipmentId;  
    totalCost = _totalCost;
    beneficiary = _beneficiary;
  }

  function nextState() public returns (string shipmentState) {
    require(currentStateIndex < (numStates - 1));
    string memory prevState = possibleStates[currentStateIndex];
    currentStateIndex = currentStateIndex.add(1);
    currentState = possibleStates[currentStateIndex];
    if (currentStateIndex == (numStates - 1)) {
      settlePayments(totalCost);
    }
    emit ChangeStatus(prevState, currentState);
    return shipmentState;
  }
}
