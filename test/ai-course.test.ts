import chai, { expect } from "chai";
import { ethers } from "hardhat";
import { solidity } from "ethereum-waffle";
chai.use(solidity);
import { Signer } from "ethers";
import {
  AfricarareAICourseCert,
  AfricarareAICourseCert__factory,
} from "../typechain";

describe("Testing", function () {
  let accounts: Signer[];
  let NFTContract: AfricarareAICourseCert;
  let NFTContractFactory: AfricarareAICourseCert__factory;
  let owner: Signer;
  const inputString = "Hello, World!";

  beforeEach(async () => {
    NFTContractFactory = <AfricarareAICourseCert__factory>(
      await ethers.getContractFactory("AfricarareAICourseCert")
    );
    NFTContract = <AfricarareAICourseCert>(
      await NFTContractFactory.deploy(
        "MyNFT",
        "MNFT",
        ethers.utils.formatBytes32String(inputString)
      )
    );
    await NFTContract.deployed();
    [owner, ...accounts] = await ethers.getSigners();
  });

  describe("Minting and Transfer", function () {
    it("Owner should be able to mint tokens", async function () {
      const tokenURI = "https://example.com/metadata/1";
      await NFTContract.mint(tokenURI);

      const ownerBalance = await NFTContract.balanceOf(
        await owner.getAddress()
      );
      expect(ownerBalance).to.equal(1);

      const tokenId = 1;
      expect(await NFTContract.tokenURI(tokenId)).to.equal(tokenURI);
    });

    it("Non-owner should not be able to mint tokens", async function () {
      const tokenURI = "https://example.com/metadata/1";
      await expect(
        NFTContract.connect(accounts[2]).mint(tokenURI)
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });

    it("Tokens should not be transferable", async function () {
      const tokenURI = "https://example.com/metadata/1";
      NFTContract.connect(accounts[0]).mintWithCode(
        tokenURI,
        ethers.utils.formatBytes32String(inputString),
        {
          value: ethers.utils.parseEther("15"), // Sending 15 ether
        }
      );

      const tokenId = 1;

      // Attempting to transfer should fail
      await expect(
        NFTContract.connect(accounts[1]).transferFrom(
          await owner.getAddress(),
          await accounts[1].getAddress(),
          tokenId
        )
      ).to.be.revertedWith("NonTransferable");

      /* // Attempting to transfer to another account should fail
      await expect(NFTContract.safeTransferFrom(await owner.getAddress(), accounts[1].getAddress(), tokenId))
        .to.be.revertedWith("NonTransferable"); */
    });
  });
});
