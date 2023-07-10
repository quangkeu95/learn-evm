pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import { SimpleStorage } from "src/Storage/SimpleStorage.sol";
import "forge-std/console.sol";

contract SimpleStorageTest is Test {
    SimpleStorage simpleStorage;
    
    function setUp() public {
        simpleStorage = new SimpleStorage();    
    }

    function testGetStorage() public {
        // we gonna validate all the storage slots available in SimpleStorage

        // slot 0
        bytes32 simpleBool = getValueAtSlotWithOffset(0, 0, 1);
        assertEq(simpleBool, bytes32(uint256(0)));
        uint8 simpleUint8 = uint8(uint256(getValueAtSlotWithOffset(0, 1, 1)));
        assertEq(simpleUint8, uint8(1));
        uint16 simpleUint16 = uint16(uint256(getValueAtSlotWithOffset(0, 2, 2)));
        assertEq(simpleUint16, uint16(2));
        uint128 simpleUint128 = uint128(uint256(getValueAtSlotWithOffset(0, 4, 16)));
        assertEq(simpleUint128, uint128(100));

        // slot 1
        uint256 simpleUint256 = uint256(getValueAtSlot(1));
        assertEq(simpleUint256, 256); 

        // slot 2
        bytes32 simpleBytes32 = getValueAtSlot(2);
        assertEq(simpleBytes32, bytes32(hex"11"));

        // slot 3
        uint256 simpleFixedArray1 = uint256(getValueAtSlot(3));
        assertEq(simpleFixedArray1, 1);

        // slot 4
        uint256 simpleFixedArray2 = uint256(getValueAtSlot(4));
        assertEq(simpleFixedArray2, 2);

        // slot 5
        uint16 simpleStructX = uint16(uint256(getValueAtSlotWithOffset(5, 0, 2)));
        assertEq(simpleStructX, uint16(10));
        uint128 simpleStructY = uint128(uint256(getValueAtSlotWithOffset(5, 2, 16))); 
        assertEq(simpleStructY, uint128(20));

        // slot 6
        uint256 simpleStructZ = uint256(getValueAtSlot(6));
        assertEq(simpleStructZ, 30);

        // slot 7
        address simpleAddress = address(uint160(uint256(getValueAtSlot(7))));
        assertEq(simpleAddress, address(uint160(123)));

        // slot 8
        address simpleAddress1 = address(uint160(uint256(getValueAtSlot(8))));
        assertEq(simpleAddress1, address(uint160(456)));
        
        // slot 9
        uint16 complexStructX1 = uint16(uint256(getValueAtSlotWithOffset(9, 0, 2)));
        assertEq(complexStructX1, uint16(4));
        uint16 complexStructX2 = uint16(uint256(getValueAtSlotWithOffset(9, 2, 2)));
        assertEq(complexStructX2, uint16(5));

        // slot 10
        uint128 complexStructY1 = uint128(uint256(getValueAtSlotWithOffset(10, 0, 16)));
        assertEq(complexStructY1, uint128(7));
        uint128 complexStructY2 = uint128(uint256(getValueAtSlotWithOffset(10, 16, 16)));
        assertEq(complexStructY2, uint128(8));

        // slot 11
        uint128 complexStructY3 = uint128(uint256(getValueAtSlotWithOffset(11, 0, 16)));
        assertEq(complexStructY3, uint128(9));
        
        // slot 12
        address complexStructZ1 = address(uint160(uint256(getValueAtSlot(12))));
        assertEq(complexStructZ1, address(uint160(10)));

        // slot 13
        address complexStructZ2 = address(uint160(uint256(getValueAtSlot(13))));
        assertEq(complexStructZ2, address(uint160(20)));

        // slot 14
        uint16 nestedStructX = uint16(uint256(getValueAtSlotWithOffset(14, 0, 2)));
        assertEq(nestedStructX, uint16(11));
        uint128 nestedStructY = uint128(uint256(getValueAtSlotWithOffset(14, 2, 16)));
        assertEq(nestedStructY, uint128(22));

        // slot 15
        uint256 nestedStructZ = uint256(getValueAtSlot(15));
        assertEq(nestedStructZ, 33);

        // slot 16
        uint256 dynamicArrLength = uint256(getValueAtSlot(16));
        assertEq(dynamicArrLength, 0);

        // if we push value into dynamicArr, dynamicArrLength will be updated
        simpleStorage.pushToDynamicArray(1111);
        dynamicArrLength = uint256(getValueAtSlot(16));
        assertEq(dynamicArrLength, 1);

        // to find the slot of item that we've already pushed into dynamic array, we use: keccak256(16)+0
        uint256 dynamicArrItem0Slot = uint256(keccak256(abi.encode(16)));
        uint256 dynamicArrItem0 = uint256(getValueAtSlot(dynamicArrItem0Slot));
        assertEq(dynamicArrItem0, 1111);

        // slot 17
        uint256 mappingPlaceholder = uint256(getValueAtSlot(17));
        assertEq(mappingPlaceholder, 0);

        // insert to mapping
        simpleStorage.insertToMapping(1, 2);
        uint256 mappingItem1Slot = uint256(keccak256(bytes.concat(abi.encode(uint256(1)), abi.encode(uint256(17)))));
        uint256 mappingItem1Value = uint256(getValueAtSlot(mappingItem1Slot));
        assertEq(mappingItem1Value, 2);

        // slot 18
        bytes32 shortBytesLength = getValueAtSlotWithOffset(18, 0, 1);
        assertEq(shortBytesLength, bytes32(uint256(2)));
        bytes32 shortBytesValue = getValueAtSlotWithOffset(18, 31, 1);
        assertEq(shortBytesValue, bytes32(uint256(18)));

        // slot 19
        bytes32 longBytesLength = getValueAtSlot(19);
        assertEq(longBytesLength, bytes32(uint256(65)));    // 32*2+1
        uint256 longBytesValueSlot = uint256(keccak256(abi.encode(19)));
        bytes32 longBytesValue = getValueAtSlot(longBytesValueSlot);
        assertEq(longBytesValue, bytes32(hex"1234560000000000000000000000000000000000000000000000000000000000")); 
        
        // slot 20
        bytes32 shortStringLength = getValueAtSlotWithOffset(20, 0, 1);
        assertEq(shortStringLength, bytes32(uint256(2)));
        bytes32 shortStringValue = getValueAtSlotWithOffset(20, 31, 1);
        assertEq(shortStringValue, bytes32(uint256(97))); // 0x65 = 97

        // slot 21
        bytes32 longStringLength = getValueAtSlot(21);
        assertEq(longStringLength, bytes32(uint256(65)));    // 32*2+1
        uint256 longStringValueSlot = uint256(keccak256(abi.encode(21)));
        bytes32 longStringValue = getValueAtSlot(longStringValueSlot);
        assertEq(longStringValue, bytes32(hex"4c6f72656d20697073756d20646f6c6f722073697420616d6574207175616d2e"));

        // slot 22

    }

    function getValueAtSlot(uint256 _slot) public view returns (bytes32) {
        return vm.load(address(simpleStorage), bytes32(_slot));
    }

    function getValueAtSlotWithOffset(uint256 _slot, uint256 _offset, uint256 _bytesLength) public view returns (bytes32 value) {
        bytes32 slotValue = getValueAtSlot(_slot);
        uint256 baseMask = type(uint256).max;

        assembly {
            let shifted := shr(mul(_offset, 8), slotValue)
            let mask := shr(sub(256, mul(_bytesLength, 8)), baseMask)
            value := and(mask, shifted)
        }
                 
    }
    
}