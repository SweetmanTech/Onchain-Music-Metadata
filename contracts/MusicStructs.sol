// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract MusicStructs {
    struct SongMetadata {
        SongContent song;
        PublishingData songPublishingData;
    }

    struct SongContent {
        Audio audio;
        Image artwork;
    }

    struct SongDetails {
        string artistName;
        AudioQuantitative audioQuantitative;
        AudioQualitative audioQualitative;
    }

    struct AudioQuantitative {
        string key; // C / A# / etc
        uint256 bpm; // 120 / 60 / 100
        uint256 duration; // 240 / 60 / 120
        string audioMimeType; // audio/wav
        uint256 trackNumber; // 1
    }

    struct AudioQualitative {
        string license; // CC0
        string externalUrl; // Link to your project website
        string isrc; // CC-XXX-YY-NNNNN
        string genre; // Rock / Pop / Metal / Hip-Hop / Electronic / Classical / Jazz / Folk / Reggae / Other
    }

    struct ProjectMetadata {
        PublishingData publishingData;
        Image artwork;
        string projectType; // Single / EP / Album
        string upc; // 03600029145
    }

    struct Collaborator {
        string name;
        string collaboratorType;
    }

    struct Image {
        string imageUri; // ipfs://{cid} or arweave
        string imageMimeType; // image/png
        string imageNft;
    }

    struct Audio {
        string losslessAudio; // ipfs://{cid} or arweave
        SongDetails songDetails;
        Lyrics lyrics;
    }

    struct Lyrics {
        string lyrics;
        string lyricsNft;
    }

    struct PublishingData {
        string title;
        string description;
        string recordLabel; // Sony / Universal / etc
        string publisher; // Sony / Universal / etc
        string locationCreated;
        string releaseDate; // 2020-01-01
    }
}
