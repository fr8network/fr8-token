pragma solidity ^0.4.18;

import './deps/Ownable.sol';
import './deps/SafeMath.sol';
import '../node_modules/zeppelin-solidity/contracts/token//ERC20/ERC20Basic.sol';
import '../node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';

contract ShipmentContract is Ownable {
  using SafeMath for uint;
  using SafeERC20 for ERC20Basic;

  mapping(uint256 => string) possibleStates;
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

  function settlePayments(ERC20Basic token) {
    token.safeTransfer(msg.sender, 10);
  }

  function ShipmentContract(uint256 _shipmentValue, uint256 _weightLbs, uint256 _numPieces, string _poNumber, uint256 _shipmentId, uint256 _totalCost) {
    numStates = 5;
    possibleStates[0] = "SHIPMENT_BOOKED";
    possibleStates[1] = "CARRIER_ASSIGNED";
    possibleStates[2] = "EN_ROUTE_TO_DESTINATION";
    possibleStates[3] = "ARRIVED_AT_DESTINATION";
    possibleStates[4] = "SHIPMENT_DELIVERED";

    currentStateIndex = 0;
    shipmentValue = _shipmentValue;
    weightLbs = _weightLbs; 
    numPieces = _numPieces; 
    poNumber = _poNumber; 
    shipmentId = _shipmentId;  
    totalCost = _totalCost;
  }

  function nextState() public returns (string shipmentState) {
    require(currentStateIndex < (numStates - 1));
    string memory prevState = possibleStates[currentStateIndex];
    uint256 currentStateIndex = currentStateIndex.add(1);
    currentState = possibleStates[currentStateIndex];
    emit ChangeStatus(prevState, currentState);
  }
}
