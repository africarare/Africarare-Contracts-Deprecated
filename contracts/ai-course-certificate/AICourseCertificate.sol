// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SecretCodeNFT is ERC721Enumerable, Ownable {
    bytes32 private _code;
    string private _baseTokenURI;

    event TokenMinted(address indexed to, uint256 indexed tokenId);

    constructor(
        string memory name,
        string memory symbol,
        string memory initialBaseURI,
        address initialOwner
    ) ERC721(name, symbol) Ownable(initialOwner) {
        _baseTokenURI = initialBaseURI;
    }

    function setCode(bytes32 code) external onlyOwner {
        _code = code;
    }

    function mintWithCode(uint256 tokenId, bytes32 providedCode) external {
        require(providedCode == _code, "Incorrect code");
        _safeMint(msg.sender, tokenId);
        emit TokenMinted(msg.sender, tokenId);
    }

    function mint(uint256 tokenId, bytes32 providedCode) external {
        require(providedCode == _code, "Incorrect code");
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
}
