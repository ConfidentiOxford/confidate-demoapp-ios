# Confidening smart contracts

This repository defines smart contracts for `Confidating`. This project is created and managed with the help of Hardhat.

## Project Structure

The project has the following main components:

- `contracts` - smart contract definitions written in Solidity. This dir contains the following sub-modules:
  - `ConfidatingProfileNFT.sol` - the main contract which extends ERC721
  - `utils` - contains utility contracts, including the `Verifier` contract
- `scrips` - contains scripts written in JS. Currently contains a deployment script for the main contact `ConfidatingProfileNFT.sol`
- `test` - contains smart contract tests, which are facilitated using hardhat and written in JS.

## Testing
To compile the contracts run:
```
npx hardhat compile
```
To test the contracts run:
```
npx hardhat test
```
This command will run the tests defined in `test` directory. If you run into issues, try cleaning the cache by running
```
npx hardhat clean
```
## Deploying
Before deploying make sure to follow these steps:
- Create and .env file where you will have to define these vars: 
  - RPC - rpc url e.g. infura, alchemy etc.
  - PRIVATE_KEY - private key of your account
  - ETHERSCAN_API_KEY (Optional) - API key for etherscan, which will be used to register the contract
- If you want to deploy to a specific network, make sure to add it to `hardhat.config.js` `networks` section
Now you are ready! To deploy the main contract run the script:
```
npx hardhat run ./scripts/deploy.js --network <network>
```
where the network references one of the network names in `hardhat.config.js` `networks` section

To verify the contract, get the address of the deployed contract (now it's logged after deployment) and run:
```
npx hardhat verify --network <network> <contract_address> <param1> <param2>...
```
where the params are the params the names of constructor params