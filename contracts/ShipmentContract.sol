pragma solidity ^0.4.18;

import './deps/Ownable.sol';
import './Queue.sol';
import './deps/SafeMath.sol';

contract ShipmentContract is Ownable {
  using SafeMath for uint;
  mapping(uint256 => address) public queue;
  uint256 first = 1;
  uint256 last = 0;
  uint256 curr;

  event ChangeStatus(string prevString, string currString);

  struct EntityStruct {
    uint entityData;
    bool isEntity;
    string entityStatus;
  }

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
  function ShipmentContract() {
    curr = 0;
  }
  
  function enqueue(address data) public {
    last += 1;
    queue[last] = data;
  }

  function dequeue() public returns (address data) {
    require(last >= first);  // non-empty queue

    data = queue[first];

    delete queue[first];
    first += 1;
  }

  function increment() public {
    uint256 prev = curr;
    uint256 next = curr.add(1);
    curr = next;
    address previous = queue[prev];
    address current = queue[curr];
    string a = entityStructs[previous].entityStatus;
    string b = entityStructs[current].entityStatus;
    ChangeStatus(a,b);

  }

  // returns the thing ahead of curr
  function optimisticNext() public constant returns (string entityStatus){
    uint256 next = curr.add(1);
    address a = queue[next];
    return entityStructs[a].entityStatus;
  }


  mapping(address => EntityStruct) public entityStructs;
  address[] public entityList;

  function isEntity(address entityAddress) public constant returns(bool isIndeed) {
      return entityStructs[entityAddress].isEntity;
  }

  function getAtIndex(uint ind) public constant returns(address entityAddress) {
    return entityList[ind];
  }

  function getEntityCount() public constant returns(uint entityCount) {
    return entityList.length;
  }

  function newEntity(address entityAddress, uint entityData, string entityStatus) public returns(uint rowNumber) {
    assert(!isEntity(entityAddress));
    entityStructs[entityAddress].entityData = entityData;
    entityStructs[entityAddress].entityStatus = entityStatus;
    entityStructs[entityAddress].isEntity = true;
    enqueue(entityAddress);
    return entityList.push(entityAddress).sub(1);
  }

  function updateEntity(address entityAddress, uint entityData, string entityStatus) public returns(bool success) {
    assert(isEntity(entityAddress));
    entityStructs[entityAddress].entityData = entityData;
    entityStructs[entityAddress].entityStatus = entityStatus;
    return true;
  }
  /*
  function ShipmentContract() public{
    address keyValueStore = new KeyValueStore();
    stores.push(keyValueStore);
  }

  function makeNew() public {
    KeyValueStore keyValueStore = KeyValueStore(stores[0]);
    address a = 0x59e4525a31C38f0879DD2894e9f13243F9c58925;
    keyValueStore.newEntity(a,1,"foo");
  }

  function getStoreCount() public constant returns (uint entityCount){
    KeyValueStore keyValueStore = KeyValueStore(stores[0]);
    return keyValueStore.getEntityCount();
  }
  */

}


