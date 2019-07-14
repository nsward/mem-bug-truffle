pragma solidity ^0.5.6;

import "./IERC20.sol";
import "../contracts/Tokens.sol";
import "truffle/Assert.sol";

contract TestTokens {
    address internal badToken;
    address internal goodToken;
    address internal constant dst = 0x2c1e2aa2E9064167815914915E764B1f106d930D;
    uint internal constant amt = uint(-1);

    event log_mem_slot_before_call(bytes32 val);
    event log_mem_slot_after_call(bytes32 val);

    function beforeEach() public {
        badToken = address(new BadToken());
        goodToken = address(new GoodToken());
    }

    function getReturn(address _target, address dst, uint amt)
        internal
        returns (bytes32 slotInitial, bytes32 slotFinal)
    {
        bytes memory cdata = abi.encodeWithSelector(
            IERC20(_target).transfer.selector,
            dst,
            amt
        );

        assembly {
            let cdStart := add(cdata, 32)
            slotInitial := mload(cdStart)
            let success := call(
                gas,
                _target,
                0,
                cdStart,
                mload(cdata),
                cdStart,
                32
            )

            switch success
            case 0 {
                revert(0,0)
            }
            case 1 {
                slotFinal := mload(cdStart)
            }
        }
    }


    function testBadToken() public {
        (bytes32 slotInitial, bytes32 slotFinal) = getReturn(badToken, dst, amt);
        emit log_mem_slot_before_call(slotInitial);
        emit log_mem_slot_after_call(slotFinal);

        // force failure to see events
        Assert.equal(uint(0), uint(1), "foo");
    }
}
