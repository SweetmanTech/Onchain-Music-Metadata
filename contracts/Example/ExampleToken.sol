// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "../OnChainMusicMetadata.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ExampleToken is OnChainMusicMetadata {
    function setupSongMetadata() internal {
        string memory title = "music nft";
        string
            memory description = "music NFT with data on-chain as Base64 encoded string.";
        string memory artist = "sweetman.eth";
        string
            memory audioUri = "ipfs://bafybeib2hyqehlrkizobojjhl6x7krll27uffx3zqs7pw3bbg6wz2wpc4m";
        string memory audioMimetype = "audio/wav";
        string memory license = "CC0";
        string memory genre = "sagrado lofi";
        string memory location = "Bueno Aires, Argentina";
        string
            memory externalUrl = "https://www.npmjs.com/package/onchain-music-metadata";

        Image memory image = getImage();
        PublishingData memory songPublishingData = PublishingData(
            title,
            description,
            "Sweetman.eth Record Label",
            "Sweetman.eth Publishing",
            location,
            "04-20-2022"
        );

        AudioQuantitative memory audioQuantitative = AudioQuantitative(
            "C",
            120,
            420,
            audioMimetype,
            1
        );
        AudioQualitative memory audioQualitative = AudioQualitative(
            license,
            externalUrl,
            "CC-XXX-YY-NNNNN",
            genre
        );

        SongDetails memory songDetails = SongDetails(
            artist,
            audioQuantitative,
            audioQualitative
        );

        Lyrics memory lyrics = Lyrics("my lyrics", "my lyrics nft location");
        Audio memory song = Audio(audioUri, songDetails, lyrics);

        SongContent memory songContent = SongContent(song, image);

        songs[1].song = songContent;
        songs[1].songPublishingData = songPublishingData;
        credits[1].push(Collaborator("sweetman.eth", "creator"));
        credits[1].push(Collaborator("sagrado.eth", "music maker"));
        tags[1].push("sagrado");
        tags[1].push("cc0");
        tags[1].push("el capitan");
    }

    function setupProjectMetadata() internal {
        PublishingData memory publishingData = PublishingData(
            "Sweets Beats",
            "My OnChain Music NFT Project",
            "Sweetman.eth Record Label",
            "Sweetman.eth Publishing",
            "Bueno Aires, Argentina",
            "04-20-2022"
        );

        _projectMetadata = ProjectMetadata(
            publishingData,
            getImage(),
            "Single",
            "03600029145"
        );
    }

    function getImage() public pure returns (Image memory) {
        string
            memory artworkUri = "ipfs://bafybeihov64eutv5yutynd5f7zg6ww2nt5yazcq6eerx77tkdh3fd3rclq";
        string memory artworkMimeType = "image/png";
        return Image(artworkUri, artworkMimeType, "music nfts");
    }
}
