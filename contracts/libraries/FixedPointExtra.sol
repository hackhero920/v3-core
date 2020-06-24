// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.6.8;

import '@uniswap/lib/contracts/libraries/FixedPoint.sol';
import 'abdk-libraries-solidity/ABDKMathQuad.sol';

// TODO(moodysalem): Move into @uniswap/lib
library FixedPointExtra {
    uint8 private constant RESOLUTION = 112;

    // multiply a UQ112x112 by a uint, returning a UQ112x112
    // reverts on overflow
    function mul112(FixedPoint.uq112x112 memory self, uint y) internal pure returns (FixedPoint.uq112x112 memory) {
        uint z;
        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
        require(z <= 2**224, "FixedPoint: MULTIPLICATION_OVERFLOW");
        return FixedPoint.uq112x112(uint224(z));
    }

    // multiply a UQ112x112 by an int and decode, returning an int112
    // TODO: fix
    // reverts on overflow
    function smul112(FixedPoint.uq112x112 memory self, int y) internal pure returns (int112) {
        int z;
        require(y == 0 || (z = int(self._x) * y) / y == int(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
        require(z <= 2**224, "FixedPoint: MULTIPLICATION_OVERFLOW");
        return int112(z >> RESOLUTION);
    }

    // add a UQ112x112 to a UQ112x112, returning a UQ112x112
    // reverts on overflow
    function add(FixedPoint.uq112x112 memory self, FixedPoint.uq112x112 memory y) internal pure returns (FixedPoint.uq112x112 memory) {
        uint224 z;
        require((z = self._x + y._x) >= self._x, 'FixedPointExtra: ADD_OVERFLOW');
        return FixedPoint.uq112x112(z);
    }

    // multiply a UQ112x112 by a UQ112x112, returning a UQ112x112
    function uqmul112(FixedPoint.uq112x112 memory self, FixedPoint.uq112x112 memory x) internal pure returns (FixedPoint.uq112x112 memory) {
        // TODO: implement this
        // silly hack to avoid linter error
        return true ? self : x;
    }

    // divide a UQ112x112 by a UQ112x112, returning a UQ112x112
    function uqdiv112(FixedPoint.uq112x112 memory self, FixedPoint.uq112x112 memory x) internal pure returns (FixedPoint.uq112x112 memory) {
        // TODO: implement this
        // silly hack to avoid linter error
        return true ? self : x;
    }

    // convert a fixed point to a quad
    function toQuad(FixedPoint.uq112x112 memory self) internal pure returns (bytes16) {
        return ABDKMathQuad.from128x128(self._x << 16);
    }

    // convert a quad to a fixed point, throws on overflow/underflow
    function fromQuad(bytes16 quad) internal pure returns (FixedPoint.uq112x112 memory) {
        int256 result = ABDKMathQuad.to128x128(quad);
        require(result < type(uint240).max, 'FixedPointExtra: OVERFLOW_UQ112x112');
        require(result > type(uint16).max, 'FixedPointExtra: UNDERFLOW_UQ112x112');
        uint224 converted = uint224(result >> 16);
        return FixedPoint.uq112x112(converted);
    }

}
