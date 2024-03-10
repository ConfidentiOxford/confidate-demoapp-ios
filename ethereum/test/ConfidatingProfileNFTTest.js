const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { ethers } = require("hardhat");
const { deployConfidatingProfileNFT } = require("../scripts/deploy");

describe("Test ConfidatingProfileNFT", function () {

    async function setup() {
        // params
        let params = {
            name_: "ConfidatingProfileNFT",
            symbol_: "CONFD"
        }

        // deploy contract
        const confidatingProfileNFT = await deployConfidatingProfileNFT(
            params.name_,
            params.symbol_
        );

        // Any other setup steps
        return { confidatingProfileNFT, params };
    }

    it("Test deployment", async function(){
        const { confidatingProfileNFT, params } = await loadFixture(setup);
        expect(await confidatingProfileNFT.name()).to.be.equal(params.name_);
        expect(await confidatingProfileNFT.symbol()).to.be.equal(params.symbol_);
    });

    it("Test createProfile", async function () {

        // setup
        const accounts = await ethers.getSigners(1);
        const { confidatingProfileNFT, params } = await loadFixture(setup);

        // invalid proof
        const _embeddings = new Array(384).fill(1);
        const _avatarUrl = "dummyUrl";
        const _pA = [2, 2];
        const _pB = [[3, 3], [3, 3]];
        const _pC = [4, 4]
        const _pubSignals = [5]

        //check revert
        await expect(
            confidatingProfileNFT
            .connect(accounts[0])
            .createProfile(_embeddings, _avatarUrl, _pA, _pB, _pC, _pubSignals)
        )
        .to
        .be
        .revertedWith("proof is invalid, unable to create the account");
    });
});