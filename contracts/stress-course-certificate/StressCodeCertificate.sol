// SPDX-License-Identifier: UNLICENCED

pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract StressCodeCertificate is ERC721URIStorage, Ownable {
    bytes32 private _code;
    mapping(address => bool) private _hasMinted;
    uint256 private _totalSupply;

    event TokenMinted(address indexed to, uint256 indexed tokenId);
    event MintingFeeUpdated(uint256 newFee);

    error NonTransferable();

    constructor(
        string memory name,
        string memory symbol,
        bytes32 code
    ) ERC721(name, symbol) {
        _code = code;
    }

    function setCode(bytes32 code) external onlyOwner {
        _code = code;
    }

    function mintWithCode(
        string memory tokenURI,
        bytes32 providedCode
    ) external {
        require(providedCode == _code, "Incorrect code");
        require(!_hasMinted[msg.sender], "Address has already minted");
        _hasMinted[msg.sender] = true;
        uint256 tokenId = _getNextTokenId();
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        emit TokenMinted(msg.sender, tokenId);
    }

    function mint(string memory tokenURI) external onlyOwner {
        uint256 tokenId = _getNextTokenId();
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        emit TokenMinted(msg.sender, tokenId);
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function _getNextTokenId() private returns (uint256) {
        _totalSupply++;
        return _totalSupply;
    }

    //Overriding the transfer functions to disable transferability
    function safeTransferFrom(
        address from,
        address to,
        uint256,
        bytes memory
    ) public override(ERC721, IERC721) {
        revert NonTransferable();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256
    ) public override(ERC721, IERC721) {
        revert NonTransferable();
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721, IERC721) {
        revert NonTransferable();
    }

    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
