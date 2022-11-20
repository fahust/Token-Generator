// SPDX-License-Identifier: MIT

// Into the Metaverse NFTs are governed by the following terms and conditions: https://a.did.as/into_the_metaverse_tc

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "erc721a/contracts/ERC721A.sol";

contract EASYERC721A is Ownable, ERC721A {
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
  ) ERC721A(name, symbol) {
    maxSupply = _maxSupply;
    unitPrice = _unitPrice;
    setBaseURI(_initBaseURI);
    baseURI = _initBaseURI;
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
  function mint(address to, uint256 quantity) external payable {
    if(msg.value >= unitPrice)
      revert NotEnoughMoney({
        value: msg.value,
        unitPrice: unitPrice
      });
    if (nextTokenIdToMint + quantity >= maxSupply)
      revert MaxSupplyReached({
        totalSupply: nextTokenIdToMint + quantity,
        maxSupply: maxSupply
      });
    _safeMint(to, quantity);
    nextTokenIdToMint += quantity;
  }

  ///@notice Function of mint token
  ///@param to address of receiver's item
  function mintOwner(address to, uint256 quantity) external onlyOwner {
    if (nextTokenIdToMint + quantity >= maxSupply)
      revert MaxSupplyReached({
        totalSupply: nextTokenIdToMint + quantity,
        maxSupply: maxSupply
      });
    _safeMint(to, quantity);
    nextTokenIdToMint += quantity;
  }

  ///@notice Function of burn token
  ///@param tokenId tokenId to burn
//   function burn(uint256 tokenId) external {
//     if(ownerOf(tokenId) != _msgSender())
//       revert NotYourToken({
//         tokenId: tokenId,
//         sender: _msgSender()
//       });
//     maxSupply -= 1;
//     burn(tokenId);
//   }

  ///@notice override of function before token transfer to pauser transfer
  function _beforeTokenTransfers(
    address from,
    address to,
    uint256 startTokenId,
    uint256 quantity
  ) internal virtual override(ERC721A) {
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
    super._beforeTokenTransfers(from, to, startTokenId, quantity);
  }
  
  
}