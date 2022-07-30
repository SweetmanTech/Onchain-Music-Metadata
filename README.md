# Music NFT OnChain Metadata

Standard for musicians pioneered by [Catalog](https://beta.catalog.works/) & [Mint Songs](https://zora.co/collections/0x2B5426A5B98a3E366230ebA9f95a24f09Ae4a584/93).

### Get Started

To add music NFT metadata to your next music NFT drop, just

1. `npm i onchain-music-metadata`
2. `import "onchain-music-metadata/contracts/OnChainMusicMetadata.sol";`
3. `contract MyMusic is OnChainMusicMetadata`

### Example Music NFT:

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./OnChainMusicMetadata.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MusicNFT is ERC721, OnChainMusicMetadata {
    uint256 songId;

    constructor() ERC721("music nft", "mnft") {
        songId = 0;
        setupSongMetadata();
    }

    function mint() public {
        songId++;
        _mint(msg.sender, songId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721)
        returns (string memory)
    {
        require(_exists(tokenId), "tokenId doesn't exist");
        return _createTokenURI(tokenId);
    }

    function setupSongMetadata() private {
        string[] memory tags;
        string memory title = "my onchain music nft";
        string memory description = "my description";
        string memory artist = "sweetman.eth";
        string
            memory artworkUri = "ipfs://bafybeihmxenyjl2gomnioljyubfzljh5apud42dftbnmab7hssi4zzpxmm";
        string memory artworkMimeType = "image/png";
        string
            memory audioUri = "ipfs://bafybeib2hyqehlrkizobojjhl6x7krll27uffx3zqs7pw3bbg6wz2wpc4m";
        string memory audioMimetype = "audio/wav";
        string memory license = "CC0";
        string memory genre = "";
        string memory location = "";
        string
            memory externalUrl = "https://www.npmjs.com/package/onchain-music-metadata";

        Image memory image = Image(artworkUri, artworkMimeType, "");
        PublishingData memory songPublishingData = PublishingData(
            title,
            description,
            "",
            "",
            location,
            ""
        );

        AudioQuantitative memory audioQuantitative = AudioQuantitative(
            "",
            0,
            0,
            audioMimetype,
            1
        );
        AudioQualitative memory audioQualitative = AudioQualitative(
            license,
            externalUrl,
            "",
            genre
        );

        SongDetails memory songDetails = SongDetails(
            artist,
            audioQuantitative,
            audioQualitative
        );

        Lyrics memory lyrics = Lyrics("", "");
        Audio memory song = Audio(audioUri, songDetails, lyrics);

        SongContent memory songContent = SongContent(song, image);

        _tokenMetadata[1].song = songContent;
        _tokenMetadata[1].songPublishingData = songPublishingData;
    }
}

```

### Credits:

- [DanielAbalde/NFT-On-Chain-Metadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata)
- [Zora Editions](https://github.com/ourzora/zora-drops-contracts/blob/main/src/metadata/EditionMetadataRenderer.sol)

### More info

Checkout our [Github](https://github.com/SweetmanTech/Onchain-Music-Metadata) for the latest changes.
