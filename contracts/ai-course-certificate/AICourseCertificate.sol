// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// TODO: Once a wallet mints, they can't mint again and tokens can't be transferred
contract SecretCodeNFT is ERC721, Ownable {
    bytes32 private _code;
    string private _baseTokenURI;
    mapping(address => bool) private _hasMinted;

    event TokenMinted(address indexed to, uint256 indexed tokenId);

    error NonTransferable();

    constructor(
        string memory name,
        string memory symbol,
        string memory initialBaseURI,
        address initialOwner
    ) ERC721(name, symbol) {
        _baseTokenURI = initialBaseURI;
    }

    function setCode(bytes32 code) external onlyOwner {
        _code = code;
    }

    function mintWithCode(uint256 tokenId, bytes32 providedCode) external {
        require(providedCode == _code, "Incorrect code");
        require(!_hasMinted[msg.sender], "Address has already minted");
        _hasMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId);
        emit TokenMinted(msg.sender, tokenId);
    }

    function mint(uint256 tokenId) external onlyOwner {
        require(!_hasMinted[msg.sender], "Address has already minted");
        _hasMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId);
        emit TokenMinted(msg.sender, tokenId);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function getCode() external view returns (bytes32) {
        return _code;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    //Overriding the transfer functions to disable transferability
    function safeTransferFrom(
        address from,
        address to,
        uint256,
        bytes memory
    ) public pure override {
        revert NonTransferable();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256
    ) public pure override {
        revert NonTransferable();
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public pure override {
        revert NonTransferable();
    }
}
