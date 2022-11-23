// SPDX-License-Identifier: MIT

// Into the Metaverse NFTs are governed by the following terms and conditions: https://a.did.as/into_the_metaverse_tc

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract EASYERC721 is Ownable, ERC721 {
  using Strings for uint256;

  error MaxSupplyReached(uint256 totalSupply, uint256 maxSupply);
  error TransferIsPaused(uint256 timestamp, uint256 pausedTransferEndDate, address from);
  error MintIsPaused(uint256 timestamp, uint256 pausedMintEndDate, address from);
  error NotEnoughMoney(uint256 value, uint256 unitPrice);
  error NotYourToken(uint256 tokenId, address sender);

  uint256 nextTokenIdToMint;
  uint256 public unitPrice;
  uint256 public maxSupply;
  uint256 private pausedTransferEndDate;
  uint256 private pausedMintEndDate;
  string public baseURI;
  string public constant baseExtension = ".json";

  constructor(
    uint256 _maxSupply,
    uint256 _unitPrice,
    string memory name,
    string memory symbol,
    string memory _initBaseURI
  ) ERC721(name, symbol) {
    maxSupply = _maxSupply;
    unitPrice = _unitPrice;
    setBaseURI(_initBaseURI);
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

  ///@notice Return the metadatas of a token, essential for opensea and other platforms
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  ///@notice Update the uri of tokens metadatas
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  ///@notice Return the metadatas of a token, essential for opensea and other platforms
  function tokenURI(
    uint256 tokenId
  ) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    string memory currentBaseURI = _baseURI();
    return
      bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  ///@notice Function of mint token
  ///@param to address of receiver's item
  function mint(address to) external payable {
    if(msg.value >= unitPrice)
      revert NotEnoughMoney({
        value: msg.value,
        unitPrice: unitPrice
      });
    if (nextTokenIdToMint + 1 >= maxSupply)
      revert MaxSupplyReached({
        totalSupply: nextTokenIdToMint,
        maxSupply: maxSupply
      });
    _safeMint(to, nextTokenIdToMint);
    nextTokenIdToMint += 1;
  }

  ///@notice Function of mint token
  ///@param to address of receiver's item
  function mintOwner(address to) external onlyOwner {
    if (nextTokenIdToMint + 1 >= maxSupply)
      revert MaxSupplyReached({
        totalSupply: nextTokenIdToMint,
        maxSupply: maxSupply
      });
    _safeMint(to, nextTokenIdToMint);
    nextTokenIdToMint += 1;
  }

  ///@notice Function of burn token
  ///@param tokenId tokenId to burn
  function burn(uint256 tokenId) external {
    if(ownerOf(tokenId) != _msgSender())
      revert NotYourToken({
        tokenId: tokenId,
        sender: _msgSender()
      });
    maxSupply -= 1;
    _burn(tokenId);
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
    address from,
    address to,
    uint256 tokenId
  ) internal virtual override(ERC721) {
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
    super._beforeTokenTransfer(from, to, tokenId);
  }
  
}