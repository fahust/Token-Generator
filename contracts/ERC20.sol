// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EASYERC20 is Ownable, ERC20 {
  error MaxSupplyReached(uint256 totalSupply, uint256 quantity, uint256 maxSupply);
  error TransferIsPaused(uint256 timestamp, uint256 pausedTransferEndDate, address from);
  error MintIsPaused(uint256 timestamp, uint256 pausedMintEndDate, address from);
  error NotEnoughMoney(uint256 value, uint256 quantity, uint256 unitPrice);
  

  uint256 public unitPrice;
  uint256 public maxSupply;
  uint256 private pausedTransferEndDate;
  uint256 private pausedMintEndDate;

  constructor(
    uint256 _maxSupply,
    uint256 _unitPrice,
    string memory name,
    string memory symbol
  ) ERC20(name, symbol) {
    maxSupply = _maxSupply * (10 ** uint256(decimals()));
    unitPrice = _unitPrice;
  }

  ///@notice update unit price for on token
  ///@param _unitPrice price in wei for one token ** decimals
  function setUnitPrice(uint256 _unitPrice) external {
    unitPrice = _unitPrice;
  }

  ///@notice update max supply tokens
  ///@param _maxSupply max token mintable
  function setMaxSupply(uint256 _maxSupply) external {
    maxSupply = _maxSupply;
  }

  ///@notice Function of mint token
  ///@param to address of receiver's item
  ///@param quantity mint a guantity of item
  function mint(address to, uint256 quantity) external payable {
    if(msg.value >= unitPrice * quantity)
      revert NotEnoughMoney({
        value: msg.value,
        quantity: quantity,
        unitPrice: unitPrice
      });
    if (totalSupply() + quantity >= maxSupply)
      revert MaxSupplyReached({
        totalSupply: totalSupply(),
        quantity: quantity,
        maxSupply: maxSupply
      });
    maxSupply += quantity;
    _mint(to, quantity * (10 ** uint256(decimals())));
  }

  ///@notice Function of mint token
  ///@param to address of receiver's item
  ///@param quantity mint a guantity of item
  function mintOwner(address to, uint256 quantity) external onlyOwner {
    if (totalSupply() + quantity >= maxSupply)
      revert MaxSupplyReached({
        totalSupply: totalSupply(),
        quantity: quantity,
        maxSupply: maxSupply
      });
    maxSupply += quantity;
    _mint(to, quantity * (10 ** uint256(decimals())));
  }

  ///@notice Function of burn token
  ///@param to address of burner's item
  ///@param quantity mint a guantity of item
  function burn(address to, uint256 quantity) external {
    maxSupply -= quantity;
    _burn(to, quantity);
  }

  ///@notice override of function before token transfer to pauser transfer
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal virtual override(ERC20) {
    if (block.timestamp < pausedTransferEndDate && from != address(0))
      revert TransferIsPaused({
        timestamp: block.timestamp,
        pausedTransferEndDate: pausedTransferEndDate,
        from: from
      });
    if (block.timestamp < pausedMintEndDate && from == address(0))
      revert MintIsPaused({
        timestamp: block.timestamp,
        pausedMintEndDate: pausedMintEndDate,
        from: from
      });
    super._beforeTokenTransfer(from, to, amount);
  }
  
}
