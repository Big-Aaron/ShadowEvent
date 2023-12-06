pragma solidity =0.6.6;
pragma experimental ABIEncoderV2;

import {Test, console2} from "forge-std/Test.sol";
import {UniswapV2Router02Shadow} from "src/UniswapV2Router02Shadow.sol";

contract ShadowTest is Test {
    UniswapV2Router02Shadow public uniswapV2Router02Shadow;
    address payable uniswapV2Router02 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address WETH_USDT_V2_POOL = 0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852;
    address CHAINLIK_ETH_USD_PRICE_FEED = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

    function setUp() public {
        vm.createSelectFork(vm.envString("ETHEREUM_MAINNET"));
        vm.label(address(uniswapV2Router02Shadow), "UniswapV2Router02Shadow");
        vm.label(address(FACTORY), "uniswapV2Factory");
        vm.label(address(WETH), "WETH");
        vm.label(address(USDT), "USDT");
        vm.label(address(WETH_USDT_V2_POOL), "WETH_USDT_V2_POOL");
        vm.label(address(CHAINLIK_ETH_USD_PRICE_FEED), "CHAINLIK_ETH_USD_PRICE_FEED");

        uniswapV2Router02Shadow = new UniswapV2Router02Shadow(FACTORY, WETH);
        vm.etch(address(uniswapV2Router02), getContractCode(address(uniswapV2Router02Shadow)));
    }

    function getContractCode(address _addr) public view returns (bytes memory _code) {
        assembly {
            // retrieve the size of the code, this needs assembly
            let size := extcodesize(_addr)
            // allocate output byte array - this could also be done without assembly
            // by using _code = new bytes(size)
            _code := mload(0x40)
            // new "memory end" including padding
            mstore(0x40, add(_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            // store length in memory
            mstore(_code, size)
            // actually retrieve the code, this needs assembly
            extcodecopy(_addr, add(_code, 0x20), 0, size)
        }
    }

    function test_Shadow_Event() public {
        uint256 amountOut = 0;
        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = USDT;
        address to = address(this);
        uint256 deadline = block.timestamp + 0xFFFFFFFF;
        UniswapV2Router02Shadow(uniswapV2Router02).swapExactETHForTokens{value: 1 ether}(amountOut, path, to, deadline);
    }

    receive() external payable {}
}
