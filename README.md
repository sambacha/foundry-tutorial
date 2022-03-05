<div align="center">

# Foundry Tutorial 
[![foundry - forge](https://img.shields.io/static/v1?label=foundry&message=forge&color=2ea44f&logo=solidity&logoColor=white)](https://github.com/gakonst/foundry)
[![foundry - cast](https://img.shields.io/badge/foundry-cast-blueviolet?logo=ethereum&logoColor=white)](https://github.com/gakonst/foundry)

</div>

---


## Overview

UniswapV3 Liquidity Testing

```sh
forge test -f $ETH_RPC_URL -vvv --fork-block-number 14327540
```

### Test Pattern: Console Emit

```solidity
  // from src/test/UniswapV3.sol
  emit log_named_uint("amount0 (USDC)", amount0);
  emit log_named_uint("amount1 (ETH)", amount1);

  emit log("------- amount0/amount1 for liquidity at range [lower, upper] at LOWER price");
  emit log_named_uint("lowerPrice (ETH/USDC)", token0Price(sqrtPriceLowerX96));
```

### Example

```sh
$ forge test -f $ETH_RPC_URL -vvv --fork-block-number 14327540
Compiling...
No files changed, compilation skipped

Running 1 test for UniswapV3Test.json:UniswapV3Test
[PASS] testExample() (gas: 36365)
Logs:
  ------- amount0/amount1 for liquidity at range [lower, upper] at CURRENT price
  currentPrice (ETH/USDC): 378261998000000
  amount0 (USDC): 9409580115
  amount1 (ETH): 5698544927171011234
  ------- amount0/amount1 for liquidity at range [lower, upper] at LOWER price
  lowerPrice (ETH/USDC): 189073881000000
  amount0 (USDC): 30718029649
  amount1 (ETH): 0
  ------- amount0/amount1 for liquidity at range [lower, upper] at UPPER price
  upperPrice (ETH/USDC): 566703047000000
  amount0 (USDC): 0
  amount1 (ETH): 10055111697431443031
```

## License

Foundry is released under [MIT/Apache-20](/LICENSE) by [@gakonst](https://github.com/gakonst) <br />
Solidity contracts are Copyright 2021 by [@MrToph](https://github.com/MrToph)
