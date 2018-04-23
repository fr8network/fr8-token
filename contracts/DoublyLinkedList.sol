pragma solidity ^0.4.21;

contract DoublyLinkedList {
  // this will be used to add location/stop data
  // will only be 2 for the demo
  struct Node {
    bytes data;
    uint256 prev;
    uint256 next;
  }

  // nodes[0].next is head, and nodes[0].prev is tail.
  Node[] public nodes;

  function DoublyLinkedList() public {
    // sentinel
    nodes.push(Node(new bytes(0), 0, 0));
  }

  function insertAfter(uint256 id, bytes data) public returns (uint256 newID) {
    // 0 is allowed here to insert at the beginning.
    require(id == 0 || isValidNode(id));

    Node storage node = nodes[id];

    nodes.push(Node({
      data: data,
      prev: id,
      next: node.next
    }));

    newID = nodes.length - 1;

    nodes[node.next].prev = newID;
    node.next = newID;
  }

  function insertBefore(uint256 id, bytes data) public returns (uint256 newID) {
    return insertAfter(nodes[id].prev, data);
  }

  function remove(uint256 id) public {
    require(isValidNode(id));

    Node storage node = nodes[id];

    nodes[node.next].prev = node.prev;
    nodes[node.prev].next = node.next;

    delete nodes[id];
  }

  function isValidNode(uint256 id) internal view returns (bool) {
    // 0 is a sentinel and therefore invalid.
    // A valid node is the head or has a previous node.
    return id != 0 && (id == nodes[0].next || nodes[id].prev != 0);
  }
}