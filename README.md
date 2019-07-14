A minimal test to pinpoint a possible memory bug. See a similar test run against hevm [here](https://github.com/nsward/mem-bug-hevm). Tokens.sol implements a "bad ERC20" with no return value from the `transfer` function, and TestTokens.sol emits events with the memory slot that the expected return value would have been copied to.

# Usage
Requires [truffle](https://www.trufflesuite.com/docs/truffle/overview) to run.

Clone and run `truffle test`. This will fail and print two events with the contents of a memory slot before and after a call is made that expects return data but doesn't get any. Run against ganache-cli, this memory is unchanged. You should be able to run the test against any client by modifying `truffle-config.js`.


