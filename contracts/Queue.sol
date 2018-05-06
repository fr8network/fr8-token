pragma solidity ^0.4.18;

contract Queue {
    mapping(uint256 => bytes) queue;
    uint256 first = 1;
    uint256 last = 0;

    function enqueue(bytes data) public {
        last += 1;
        queue[last] = data;
    }

    function dequeue() public returns (bytes data) {
        require(last >= first);  // non-empty queue

        data = queue[first];

        delete queue[first];
        first += 1;
    }
}