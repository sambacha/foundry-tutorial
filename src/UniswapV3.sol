// SPDX-License-Identifier: UNLICNESED
pragma solidity ^0.8.4;

import "ds-test/test.sol";
import { LiquidityAmounts } from "./libs/LiquidityAmounts.sol";
import { FullMath } from "./libs/FullMath.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

contract UniswapV3 is DSTest {
    // USDC (token0) <> ETH (token1) 0.05% fee pool https://info.uniswap.org/#/pools/0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640
    IUniswapV3Pool constant pool = IUniswapV3Pool(0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640);

    function compute() external returns (bytes memory) {
        // token1 per token0, ETH per USDC in (18 - 6) = 12 decimals
        (uint160 sqrtPriceX96, int24 tick, , , , , ) = pool.slot0();
        uint128 liquidity = 1e15;
        // assume we provided liquidity at 50% around the current pool price
        uint160 sqrtPriceLowerX96 = sqrtPriceX96 * 707 / 1000; // roughly 50% of current price (multiplied by sqrt(0.5))
        uint160 sqrtPriceUpperX96 = sqrtPriceX96 * 1224 / 1000; // // roughly 150% of current price (multiplied by sqrt(1.5))

        emit log("------- amount0/amount1 for liquidity at range [lower, upper] at CURRENT price");
        emit log_named_uint("currentPrice (ETH/USDC)", token0Price(sqrtPriceX96));
        (uint256 amount0, uint256 amount1) = LiquidityAmounts.getAmountsForLiquidity(
            sqrtPriceX96,
            sqrtPriceLowerX96,
            sqrtPriceUpperX96,
            liquidity
        );
        emit log_named_uint("amount0 (USDC)", amount0);
        emit log_named_uint("amount1 (ETH)", amount1);

        emit log("------- amount0/amount1 for liquidity at range [lower, upper] at LOWER price");
        emit log_named_uint("lowerPrice (ETH/USDC)", token0Price(sqrtPriceLowerX96));
        (amount0, amount1) = LiquidityAmounts.getAmountsForLiquidity(
            sqrtPriceLowerX96,
            sqrtPriceLowerX96,
            sqrtPriceUpperX96,
            liquidity
        );
        emit log_named_uint("amount0 (USDC)", amount0);
        emit log_named_uint("amount1 (ETH)", amount1);

        emit log("------- amount0/amount1 for liquidity at range [lower, upper] at UPPER price");
        emit log_named_uint("upperPrice (ETH/USDC)", token0Price(sqrtPriceUpperX96));
        (amount0, amount1) = LiquidityAmounts.getAmountsForLiquidity(
            sqrtPriceUpperX96,
            sqrtPriceLowerX96,
            sqrtPriceUpperX96,
            liquidity
        );
        emit log_named_uint("amount0 (USDC)", amount0);
        emit log_named_uint("amount1 (ETH)", amount1);

        return abi.encodePacked(amount0, amount1);
    }

    function token0Price(uint160 token0SqrtPriceX96) internal returns (uint256) {
        // token1 per token0, ETH per USDC in (18 - 6) = 12 decimals
        return FullMath.mulDiv(token0SqrtPriceX96, token0SqrtPriceX96, 2**192) * 1e6;
    }

    function token1Price(uint160 token0SqrtPriceX96) internal returns (uint256) {
        // token1 per token0, ETH per USDC in (18 - 6) = 12 decimals
        return 1e12 / FullMath.mulDiv(token0SqrtPriceX96, token0SqrtPriceX96, 2**192);
    }
}

contract UniswapV3Test is DSTest {
    UniswapV3 test;
    function setUp() public {
        test = new UniswapV3();
    }

    function testExample() public {
        (uint256 amount0, uint256 amount1) = abi.decode(test.compute(), (uint256, uint256));
        assertTrue(true);
    }
}
