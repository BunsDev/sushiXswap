// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../base/ImmutableState.sol";

abstract contract Stargate is ImmutableState {
    using SafeERC20 for IERC20;

    struct TeleportParams {
        uint16 dstChainId;
        address token;
        uint256 srcPoolId;
        uint256 dstPoolId;
        uint256 amount;
        uint256 amountMin;
        uint256 dustAmount;
        address receiver;
        address to;
        uint256 gas;
    }

    function approveToStargateRouter(IERC20 token) external {
        token.safeApprove(address(stargateRouter), type(uint256).max);
    }

    function _teleport(
        TeleportParams memory params,
        uint8[] memory actions,
        uint256[] memory values,
        bytes[] memory datas
    ) internal {
        bytes memory payload = abi.encode(params.to, actions, values, datas);

        stargateRouter.swap{value: address(this).balance}(
            params.dstChainId,
            params.srcPoolId,
            params.dstPoolId,
            payable(msg.sender),
            params.amount != 0
                ? params.amount
                : IERC20(params.token).balanceOf(address(this)),
            params.amountMin,
            IStargateRouter.lzTxObj(
                params.gas,
                params.dustAmount,
                abi.encodePacked(params.receiver)
            ),
            abi.encodePacked(params.receiver),
            payload
        );
    }
}
