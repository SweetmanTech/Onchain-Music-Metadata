# Music NFT OnChain Metadata

Standard for musicians pioneered by [Catalog](https://beta.catalog.works/) & [Mint Songs](https://zora.co/collections/0x2B5426A5B98a3E366230ebA9f95a24f09Ae4a584/93).

```diff
- WARNING: these contracts are unaudited
```

### You Newest Tool for Music NFTs (100% on chain)

- [Your Music NFT Smart Contract (ERC721)](https://mumbai.polygonscan.com/address/0xb7CF570F9a816CEB90b780C324ECcdb6Fa6C722F#code).
- [Your Music NFT in OpenSea](https://testnets.opensea.io/assets/mumbai/0xedc026452bfb91112230270049939afcb4c78a75/1)
- Works out of the box.
- 100% free CC0 technology (MIT License - use this w/o crediting me).

### Get Started

To add music NFT metadata to your next music NFT drop, just

1. `npm i onchain-music-metadata`
2. `import "onchain-music-metadata/contracts/OnChainMusicMetadata.sol";`
3. `contract MyMusic is OnChainMusicMetadata`
4. use the `musicTokenUri(tokenId)` method freely.

### Example Music NFT:

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "onchain-music-metadata/contracts/Example/ExampleToken.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MusicNFT is ERC721, ExampleToken {
    uint256 songId;

    constructor() ERC721("music nft", "mnft") {
        songId = 0;
        setupSongMetadata();
        setupProjectMetadata();
    }

    function mint() public {
        songId++;
        _mint(msg.sender, songId);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override(ERC721)
        returns (string memory)
    {
        require(_exists(_tokenId), "tokenId doesn't exist");
        return musicTokenUri(_tokenId);
    }
}
```

### Credits:

- [DanielAbalde/NFT-On-Chain-Metadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata)
- [Zora Editions](https://github.com/ourzora/zora-drops-contracts/blob/main/src/metadata/EditionMetadataRenderer.sol)
- [Nouns DAO #177](https://nouns.wtf/)

### More info

Checkout our [Github](https://github.com/SweetmanTech/Onchain-Music-Metadata) for the latest changes.
