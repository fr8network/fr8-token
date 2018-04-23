pragma solidity ^0.4.21;

import './deps/Ownable.sol';

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

  struct Status {
    QuoteStatus[] quoteStatuses;
    BookedStatus[] bookedStatuses;
    DeliveredStatus[] deliveredStatuses;
  } 

  mapping (uint => uint) statusMapping;
  
  uint public current; // this will only apply to Booked for now

  function getValueOne() public view returns(uint) {
      return statusMapping[uint(BookedStatus.CARRIER_FOUND)];
  }

  function typeCastUintToEnum() public view returns (BookedStatus) {
    return BookedStatus(1);
  }


}


