pragma solidity ^0.8.19;

contract SimpleStorage {
    // slot 0
    uint8 simpleUint8 = 1;
    // slot 0
    uint16 simpleUint16 = uint16(20);
    // slot 0
    uint128 simpleUint128 = uint128(128);
    // slot 1
    uint256 simpleUint256 = uint256(256);

    function getValueAtSlot(uint256 _x) public returns (uint256 ret) {
        assembly {
            ret := sload(_x)
        }
    }
}
