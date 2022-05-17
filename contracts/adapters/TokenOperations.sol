// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

abstract contract TokenOperations {
    using SafeERC20 for IERC20;

    function _transferTokens(
        IERC20 token,
        address to,
        uint256 amount
    ) internal {
        if (address(token) != address(0)) {
            token.safeTransfer(to, amount);
        } else {
            payable(to).transfer(amount);
        }
    }
}
