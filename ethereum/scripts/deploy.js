const { ethers } = require("hardhat");


async function deployConfidatingProfileNFT(name_, symbol_){
    //deploy pythia factory
    const params = { name_, symbol_ }

    const ConfidatingProfileNFT = await ethers.getContractFactory(
        "ConfidatingProfileNFT"
    );
    const confidatingProfileNFT = await ConfidatingProfileNFT.deploy(
        params.name_,
        params.symbol_
    );
    await confidatingProfileNFT.deployed();
    console.log(
        `ConfidatingProfileNFT deployed to address:${confidatingProfileNFT.address}`
    );
    return confidatingProfileNFT

}

deployConfidatingProfileNFT("ConfidatingProfileNFTTest", "TEST_CONFD").catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

module.exports = { deployConfidatingProfileNFT };