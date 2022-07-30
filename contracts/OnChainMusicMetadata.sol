// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./MusicStructs.sol";

contract OnChainMusicMetadata is MusicStructs {
    mapping(uint256 => SongMetadata) public songs; // metadata for each token
    ProjectMetadata public _projectMetadata; // metadata for the project
    mapping(uint256 => Collaborator[]) public credits; // mapping songId to Collaborator array (ex. [{name: "sweetman.eth", collaboratorType: "smart contract engineer"}, {name: "sagrado.eth", collaboratorType: "producer"}])
    mapping(uint256 => string[]) public tags; // mapping songId to tags array (ex. ["sagrado", "cc0", "el capitan"])

    /// @notice music metadata (100% on-chain)
    /// @param _tokenId the token id
    /// @return _musicMetadata for all marketplaces (Zora / OpenSea / Rarible / etc.)
    function musicTokenUri(uint256 _tokenId)
        public
        view
        virtual
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(_musicTokenUri(_tokenId), "}}")
                    )
                )
            );
    }

    function _musicTokenUri(uint256 _tokenId)
        internal
        view
        returns (string memory)
    {
        string[47] memory keys = _getKeys();
        string[47] memory values = _getValues(_tokenId);
        string memory response = "";
        for (uint256 i = 0; i < values.length; i++) {
            response = string(abi.encodePacked(response, keys[i], values[i]));
        }
        return response;
    }

    function _getString(string memory _string)
        public
        pure
        returns (string memory)
    {
        return string(abi.encodePacked('"', _string, '"'));
    }

    function _getArrayString(string[] memory _array)
        public
        pure
        returns (string memory)
    {
        string memory _string = "[";
        for (uint256 i = 0; i < _array.length; i++) {
            _string = string(abi.encodePacked(_string, _getString(_array[i])));
            if (i < _array.length - 1) {
                _string = string(abi.encodePacked(_string, ","));
            }
        }
        _string = string(abi.encodePacked(_string, "]"));
        return _string;
    }

    function _getCollaboratorString(SongMetadata storage _song)
        internal
        view
        returns (string memory)
    {
        string memory _string = "[";
        uint256 trackNumber = _song
            .song
            .audio
            .songDetails
            .audioQuantitative
            .trackNumber;
        for (uint256 i = 0; i < credits[trackNumber].length; i++) {
            _string = string(abi.encodePacked(_string, '{"name":'));
            _string = string(
                abi.encodePacked(
                    _string,
                    _getString(credits[trackNumber][i].name)
                )
            );
            _string = string(abi.encodePacked(_string, ',"collaboratorType":'));
            _string = string(
                abi.encodePacked(
                    _string,
                    _getString(credits[trackNumber][i].collaboratorType),
                    "}"
                )
            );
            if (i < credits[trackNumber].length - 1) {
                _string = string(abi.encodePacked(_string, ","));
            }
        }
        _string = string(abi.encodePacked(_string, "]"));
        return _string;
    }

    /// @notice the keys to be a music nft
    /// @return _keys for music nft metadata
    function _getKeys() public pure returns (string[47] memory) {
        return [
            '{"name":',
            ',"description":',
            ',"image":',
            ',"version":"0.1","title":',
            ',"artist":',
            ',"duration":',
            ',"mimeType":',
            ',"losslessAudio":',
            ',"trackNumber":',
            ',"genre":',
            ',"tags":',
            ',"bpm":',
            ',"key":',
            ',"license":',
            ',"locationCreated":',
            ',"external_url":',
            ',"animation_url":',
            ',"project":{"title":',
            ',"artwork":{"uri":',
            ',"mimeType":',
            ',"nft":',
            '},"description":',
            ',"type":',
            ',"originalReleaseDate":',
            ',"recordLabel":',
            ',"publisher":',
            ',"upc":',
            '},"isrc":',
            ',"artwork":{"uri":',
            ',"mimeType":',
            ',"nft":',
            '},"lyrics":{"text":',
            ',"nft":',
            '},"visualizer":{"uri":',
            ',"mimeType":',
            ',"nft":',
            '},"originalReleaseDate":',
            ',"recordLabel":',
            ',"publisher":',
            ',"credits":',
            ',"attributes":{"artist":',
            ',"project":',
            ',"bpm":',
            ',"key":',
            ',"genre":',
            ',"recordLabel":',
            ',"license":'
        ];
    }

    function _getValues(uint256 _tokenId)
        public
        view
        returns (string[47] memory)
    {
        string[47] memory values;
        string memory description = _getString(
            songs[_tokenId].songPublishingData.description
        );
        string memory losslessAudio = values[0] = _getString(
            songs[_tokenId].song.audio.losslessAudio
        );
        string memory title = _getString(
            songs[_tokenId].songPublishingData.title
        );
        string memory artworkUri = _getString(
            songs[_tokenId].song.artwork.imageUri
        );
        string memory artworkMimeType = _getString(
            songs[_tokenId].song.artwork.imageMimeType
        );
        string memory artworkNft = _getString(
            songs[_tokenId].song.artwork.imageNft
        );
        string memory artistName = _getString(
            songs[_tokenId].song.audio.songDetails.artistName
        );
        string memory bpm = Strings.toString(
            songs[_tokenId].song.audio.songDetails.audioQuantitative.bpm
        );
        string memory songKey = _getString(
            songs[_tokenId].song.audio.songDetails.audioQuantitative.key
        );

        values[1] = description;
        values[2] = artworkUri;
        values[3] = title;
        values[4] = artistName;
        values[5] = Strings.toString(
            songs[_tokenId].song.audio.songDetails.audioQuantitative.duration
        );
        values[6] = _getString(
            songs[_tokenId]
                .song
                .audio
                .songDetails
                .audioQuantitative
                .audioMimeType
        );
        values[7] = losslessAudio;
        values[8] = Strings.toString(
            songs[_tokenId].song.audio.songDetails.audioQuantitative.trackNumber
        );
        values[9] = _getString(
            songs[_tokenId].song.audio.songDetails.audioQualitative.genre
        );
        values[10] = _getArrayString(tags[_tokenId]);
        values[11] = bpm;
        values[12] = songKey;
        values[13] = _getString(
            songs[_tokenId].song.audio.songDetails.audioQualitative.license
        );
        values[14] = _getString(
            songs[_tokenId].songPublishingData.locationCreated
        );
        values[15] = _getString(
            songs[_tokenId].song.audio.songDetails.audioQualitative.externalUrl
        );
        values[16] = losslessAudio;
        values[17] = title;
        values[18] = _getString(_projectMetadata.artwork.imageUri);
        values[19] = _getString(_projectMetadata.artwork.imageMimeType);
        values[20] = _getString(_projectMetadata.artwork.imageNft);
        values[21] = description;
        values[22] = _getString(_projectMetadata.projectType);
        values[23] = _getString(_projectMetadata.publishingData.releaseDate);
        values[24] = _getString(_projectMetadata.publishingData.recordLabel);
        values[25] = _getString(_projectMetadata.publishingData.publisher);
        values[26] = _getString(_projectMetadata.upc);
        values[27] = _getString(
            songs[_tokenId].song.audio.songDetails.audioQualitative.isrc
        );
        values[28] = artworkUri;
        values[29] = artworkMimeType;
        values[30] = artworkNft;
        values[31] = _getString(songs[_tokenId].song.audio.lyrics.lyrics);
        values[32] = _getString(songs[_tokenId].song.audio.lyrics.lyricsNft);
        values[33] = artworkUri;
        values[34] = artworkMimeType;
        values[35] = artworkNft;
        values[36] = _getString(songs[_tokenId].songPublishingData.releaseDate);
        values[37] = _getString(songs[_tokenId].songPublishingData.recordLabel);
        values[38] = _getString(songs[_tokenId].songPublishingData.publisher);
        values[39] = _getCollaboratorString(songs[_tokenId]);
        values[40] = artistName;
        values[41] = _getString(_projectMetadata.publishingData.title);
        values[42] = bpm;
        values[43] = songKey;
        values[44] = _getString(
            songs[_tokenId].song.audio.songDetails.audioQualitative.genre
        );
        values[45] = _getString(songs[_tokenId].songPublishingData.recordLabel);
        values[46] = _getString(
            songs[_tokenId].song.audio.songDetails.audioQualitative.license
        );
        return values;
    }
}
