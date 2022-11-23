// SPDX-License-Identifier: MIT

// Into the Metaverse NFTs are governed by the following terms and conditions: https://a.did.as/into_the_metaverse_tc

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract EASYERC1155 is Ownable, ERC1155 {
  using Strings for uint256;

  error MaxSupplyReached(uint256 tokenId, uint256 maxSupply);
  error TransferIsPaused(uint256 timestamp, uint256 pausedTransferEndDate, address from);
  error MintIsPaused(uint256 timestamp, uint256 pausedMintEndDate, address from);
  error NotEnoughMoney(uint256 value, uint256 unitPrice);
  error NotYourToken(uint256 tokenId, address sender);

  uint256 public unitPrice;
  uint256 public maxSupply;
  uint256 private pausedTransferEndDate;
  uint256 private pausedMintEndDate;
  string public baseURI;
  string public constant baseExtension = ".json";

  constructor(
    uint256 _maxSupply,
    uint256 _unitPrice,
    string memory _initBaseURI
  ) ERC1155(_initBaseURI) {
    maxSupply = _maxSupply;
    unitPrice = _unitPrice;
    baseURI = _initBaseURI;
  }

  ///@notice update unit price for on token
  ///@param _unitPrice price in wei for one token ** decimals
  function setUnitPrice(uint256 _unitPrice) external onlyOwner {
    unitPrice = _unitPrice;
  }

  ///@notice update max supply tokens
  ///@param _maxSupply max token mintable
  function setMaxSupply(uint256 _maxSupply) external onlyOwner {
    maxSupply = _maxSupply;
  }

  ///@notice Function of mint token
  ///@param to address of receiver's item
  function mint(address to, uint256 tokenId, uint256 amount) external payable {
    if(msg.value >= unitPrice * amount)
      revert NotEnoughMoney({
        value: msg.value,
        unitPrice: unitPrice
      });
    if (tokenId >= maxSupply)
      revert MaxSupplyReached({
        tokenId: tokenId,
        maxSupply: maxSupply
      });
    _mint(to, tokenId, amount, "");
  }

  ///@notice Function of mint token
  ///@param to address of receiver's item
  function mintOwner(address to, uint256 tokenId, uint256 amount) external onlyOwner {
    if (tokenId >= maxSupply)
      revert MaxSupplyReached({
        tokenId: tokenId,
        maxSupply: maxSupply
      });
    _mint(to, tokenId, amount, "");
  }

  ///@notice Function of burn token
  ///@param tokenId tokenId to burn
  function burn(uint256 tokenId, uint256 quantity) external {
    _burn(_msgSender(), tokenId, quantity);
  }

  ///@notice Withdraw funds of this contract to an address wallet
  function withdraw() external onlyOwner {
    payable(_msgSender()).transfer(address(this).balance);
  }

  ///@notice Pause mint of token between address before time pausedMintEndDate
  ///@param time timestamp until which the contract will be paused for mint
  function setPausedMintEndDate(uint256 time) external onlyOwner {
    pausedMintEndDate = time;
  }

  ///@notice Pause transfer of token between address before time pausedTransferEndDate
  ///@param time timestamp until which the contract will be paused for transfer
  function setPausedTransferEndDate(uint256 time) external onlyOwner {
    pausedTransferEndDate = time;
  }

  ///@notice override of function before token transfer to pauser transfer
  function _beforeTokenTransfer(
    address operator,
    address from,
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) internal virtual override(ERC1155) {
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
    super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
  }
  
  
}