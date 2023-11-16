// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SecretCodeNFT is ERC721, Ownable {
    bytes32 private _code;
    string private _baseTokenURI;
    mapping(address => bool) private _hasMinted;

    event TokenMinted(address indexed to, uint256 indexed tokenId);

    error NonTransferable();

    constructor(
        string memory name,
        string memory symbol,
        string memory initialBaseURI
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

    // Override the transfer functions to disable transferability
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        revert NonTransferable();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override {
        revert NonTransferable();
    }
}
