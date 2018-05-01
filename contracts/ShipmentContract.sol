pragma solidity ^0.4.18;

import './deps/Ownable.sol';
import './DoublyLinkedList.sol';

contract ShipmentContract is Ownable {

  enum QuoteStatus {
    AWAITING_CARRIER
  }
  
  enum BookedStatus { 
    CARRIER_FOUND, 
    CARRIER_ACCEPTED_AND_ASSIGEND, 
    AWAITING_PICKUP,
    LOADING,
    EN_ROUTE,
    ARRIVED,
    SHIPMENT_ACCEPTED,
    DEPARTED,
    COMPLETE 
  }

  enum DeliveredStatus {
    ACCEPTED,
    ISSUE_RAISED,
    AWAITING_RETURN,
    REFUNDED
  }

  struct Phase {
    QuoteStatus q;
    BookedStatus b;
    DeliveredStatus d;
  }

  // function updateStruct() public {
  //   Phase storage q = QuoteStatus.AWAITING_CARRIER;
  // }

  mapping (uint => uint) statusMapping;
  

  function getValueOne() public view returns(uint) {
      return statusMapping[uint(BookedStatus.CARRIER_FOUND)];
  }

  function typeCastUintToEnum() public view returns (BookedStatus) {
    return BookedStatus(1);
  }

  mapping(uint => QuoteStatus) public quoteMapping;

  // function setMapping(uint key, uint value) public {
    
  //   quoteMapping[key]  = value;
  // }

  function getEnum() public view returns (DeliveredStatus){
    return DeliveredStatus.AWAITING_RETURN;
  }
  function getEnumAsNumber() public view returns (uint){
    return uint(DeliveredStatus.AWAITING_RETURN);
  }

  function setPhase(uint i, uint j) public{
    if (uint i === 0) {
      
    }
  }
  
  function getEnumAfterTypeCasting(uint k) public view returns (DeliveredStatus) {
    return DeliveredStatus(k);
  }


  /*
   * Spec: frontend user needs a way to see the status of their shipping
   *       in real time
   *
   * todo: add at least 6 lines of technical description for an engineer
   * note: leave nothing to the imagination. include acceptance criteria
   */
   event statusChange(uint curr);
  
   /*
    * Spec: user needs a way to sign a transaction to move the status 
    *       of the shipment to the next field iteratively 
    */
    function nextStatus() public returns (bool success){
        // create mapping object to check which phase (quote, book, deliv)

        // add logic to check which enum it is, and whether its at end
        uint curr = 1;

        if (curr == uint(BookedStatus.COMPLETE)) {
          return false;
        }
        curr += curr + 1;

        // can you do reverse typecast?

        
        return true;
    }


}


