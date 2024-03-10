// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./utils/Counters.sol";
import "./utils/Groth16Verifier.sol";


contract ConfidatingProfileNFT is ERC721 {
    using Counters for Counters.Counter;

    event ProfileCreated(
        address indexed _address,
        string _avatarUrl,
        uint256[384] _embedding,
        uint256 _creationTimestamp
    );

    struct Profile {
        uint256[384] embedding;
        string avatarUrl;
        uint256 creationTimestamp;

    }

    // profiles mapping
    mapping(address => Profile) private profiles;

    // verifier
    Groth16Verifier private verifier;

    // token id counter
    Counters.Counter private _tokenIdCounter;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_){
        verifier = new Groth16Verifier();
    }

    /**
    * @dev mint
    * @param _embedding uint256[384] -  embedding vector for the user
    * @param _avatarUrl string - avatarUrl for the user
    */
    function createProfile(
        uint256[384] calldata _embedding,
        string calldata _avatarUrl,
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[1] calldata _pubSignals
    ) external {

        // require that user previously did not have NFTS
        require(
            balanceOf(msg.sender) < 1,
            "unable to mint, user has previosly minted the nft"
        );

        // verify proof
        require(
            verifier.verifyProof(_pA, _pB, _pC, _pubSignals),
            "proof is invalid, unable to create the account"
        );

        // store profile data 
        Profile memory profile = Profile(
            {
                embedding: _embedding,
                avatarUrl: _avatarUrl,
                creationTimestamp: block.timestamp
            }
        );
        profiles[msg.sender] = profile;

        // mint nft
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);

        // emit event
        emit ProfileCreated(
            msg.sender,
            _avatarUrl,
            _embedding,
            block.timestamp
        );
    }

}