pragma solidity ^0.8.19;

contract SimpleStorage {
    // slot 0
    bool simpleBool;
    // slot 0
    uint8 simpleUint8 = 1;
    // slot 0
    uint16 simpleUint16 = 2;
    // slot 0
    uint128 simpleUint128 = 100;
    // slot 1
    uint256 simpleUint256 = 256;
    // slot 2
    bytes32 simpleBytes32 = hex"11";
    // slot 3 for simpleFixedArray[0], slot 4 for simpleFixedArray[1]
    uint256[2] simpleFixedArray = [1, 2];
      
    struct SimpleStruct {
        uint16 x;
        uint128 y;
        uint256 z; 
    }
    // slot 5 for simpleStruct.x, slot 5 for simpleStruct.y, slot 6 for simpleStruct.z
    SimpleStruct simpleStruct = SimpleStruct({ x: 10, y: 20, z: 30});

    // slot 7
    address simpleAddress = address(uint160(123));
    // slot 8
    address simpleAddress1 = address(uint160(456)); 

    struct ComplexStruct {
        uint16[2] x;
        uint128[3] y;
        address[2] z;
        SimpleStruct nestedStruct;
    }
    ComplexStruct complexStruct = ComplexStruct({
        x: [uint16(4), uint16(5)],
        y: [uint128(7), uint128(8), uint128(9)],
        z: [address(uint160(10)), address(uint160(20))],
        nestedStruct: SimpleStruct({ x: 11, y: 22, z: 33})
    });
    // slot 9 for complexStruct.x[0], slot 9 for complexStruct.x[1]
    // slot 10 for complexStruct.y[0], slot 10 for complextStruct.y[1]
    // slot 11 for complextStruct.y[2]
    // slot 12 for complexStruct.z[0]
    // slot 13 for complexStruct.z[1]
    // slot 14 for complexStruct.nestedStruct.x, y
    // slot 15 for complexStruct.nestedStruct.z

    // dynamic array 
    // slot 16
    uint256[] dynamicArr;

    // mapping
    // slot 17
    mapping(uint256 => uint256) mappingUint256;

    // bytes
    // slot 18 for shortBytes length and shortBytes value
    bytes shortBytes = hex"12";
    // slot 19 for longBytes length
    bytes longBytes = hex"1234560000000000000000000000000000000000000000000000000000000000";
    
    // string
    // slot 20 for shortString length*2 and shortString value
    string shortString = "a";
    // slot 21 for longBytes length*2 +1
    string longString = "Lorem ipsum dolor sit amet quam.";
    
    // nested mapping
    // slot 22
    mapping(uint256 => mapping(uint256 => SimpleStruct)) complexMapping;

    function pushToDynamicArray(uint256 value) public {
        dynamicArr.push(value);

        // // in assembly
        // uint256 arrLen;
        // uint256 dynamicArrSlot;
        // assembly {
        //     // get dynamicArr length
        //     dynamicArrSlot := dynamicArr.slot
        //     arrLen := sload(dynamicArr.slot)
        // }

        // // new item will be stored at slot keccak256(dynamicArrSlot) + arrLen
        // uint256 itemSlot = uint256(keccak256(abi.encode(dynamicArrSlot))) + arrLen;
        
        // assembly {
        //     let newArrLen := add(arrLen, 1)
        //     // store value at item slot
        //     sstore(itemSlot, value)
        //     // increase dynamicArr length
        //     sstore(dynamicArrSlot, newArrLen)
        // }
    }

    function insertToMapping(uint256 key, uint256 value) public {
        mappingUint256[key] = value;
    }
}
