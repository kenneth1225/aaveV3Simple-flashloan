// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;
import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "node_modules/@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "node_modules/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
contract aaveFlashLoan is FlashLoanSimpleReceiverBase {
    
    address payable public owner;
    IERC20 private constant USDC = IERC20(0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8);
    constructor(address _provider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_provider)) 
        {
            owner = payable(msg.sender);
        }
    function startFlashLoan() external {
        require(msg.sender == owner, "not owner");
        address receiverAddress = address(this);
        address asset = address(USDC);
        uint256 amount = 10000 * (10 ** 6);
        bytes memory params = "";
        uint16 referralCode = 0;
        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }

    function executeOperation(address asset,uint256 amount,
    uint256 premium,address initiator,bytes calldata params) external override returns(bool) {
        //code
        uint256 allAmount = amount + premium;
        IERC20(asset).approve(address(POOL), allAmount);
        return true;
    }

}