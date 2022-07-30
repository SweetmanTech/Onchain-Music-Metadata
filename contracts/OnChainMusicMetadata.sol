// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./MusicStructs.sol";

contract OnChainMusicMetadata is MusicStructs {
    mapping(uint256 => SongMetadata) public _tokenMetadata; // metadata for each token
    ProjectMetadata public _projectMetadata; // metadata for the project

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
            _string = string(abi.encodePacked(_string, _array[i]));
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
        for (uint256 i = 0; i < _song.collaboratorCount; i++) {
            _string = string(abi.encodePacked(_string, "{name:"));
            _string = string(abi.encodePacked(_string, _song.credits[i].name));
            _string = string(abi.encodePacked(_string, ",collaboratorType:"));
            _string = string(
                abi.encodePacked(
                    _string,
                    _song.credits[i].collaboratorType,
                    "}"
                )
            );
            if (i < _song.collaboratorCount - 1) {
                _string = string(abi.encodePacked(_string, ","));
            }
        }
        _string = string(abi.encodePacked(_string, "]"));
        return _string;
    }

    function _createTokenURI(uint256 tokenId)
        internal
        view
        virtual
        returns (string memory)
    {
        string memory response = "";
        string[47] memory keys = [
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
        string[47] memory values = _getValues(tokenId);
        for (uint256 i = 0; i < values.length; i++) {
            string memory key = keys[i];
            string memory value = values[i];
            response = string(abi.encodePacked(response, key, value));
        }
        response = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(abi.encodePacked(response, "}}"))
            )
        );
        return response;
    }

    function _getValues(uint256 _tokenId)
        public
        view
        returns (string[47] memory)
    {
        string[47] memory values;
        string memory description = _getString(
            _tokenMetadata[_tokenId].songPublishingData.description
        );
        string memory losslessAudio = values[0] = _getString(
            _tokenMetadata[_tokenId].songPublishingData.title
        );
        string memory title = _getString(
            _tokenMetadata[_tokenId].songPublishingData.title
        );
        string memory artworkUri = _getString(
            _tokenMetadata[_tokenId].song.artwork.imageUri
        );
        string memory artworkMimeType = _getString(
            _tokenMetadata[_tokenId].song.artwork.imageMimeType
        );
        string memory artworkNft = _getString(
            _tokenMetadata[_tokenId].song.artwork.imageNft
        );
        string memory artistName = _getString(
            _tokenMetadata[_tokenId].song.audio.songDetails.artistName
        );
        string memory tags = _getArrayString(_tokenMetadata[_tokenId].tags);
        string memory bpm = Strings.toString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQuantitative
                .bpm
        );
        string memory songKey = _getString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQuantitative
                .key
        );

        values[1] = description;
        values[2] = artworkUri;
        values[3] = title;
        values[4] = artistName;
        values[5] = Strings.toString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQuantitative
                .duration
        );
        values[6] = _getString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQuantitative
                .audioMimeType
        );
        values[7] = losslessAudio;
        values[8] = Strings.toString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQuantitative
                .trackNumber
        );
        values[9] = _getString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQualitative
                .genre
        );
        values[10] = tags;
        values[11] = bpm;
        values[12] = songKey;
        values[13] = _getString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQualitative
                .license
        );
        values[14] = _getString(
            _tokenMetadata[_tokenId].songPublishingData.locationCreated
        );
        values[15] = _getString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQualitative
                .externalUrl
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
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQualitative
                .isrc
        );
        values[28] = artworkUri;
        values[29] = artworkMimeType;
        values[30] = artworkNft;
        values[31] = _getString(
            _tokenMetadata[_tokenId].song.audio.lyrics.lyrics
        );
        values[32] = _getString(
            _tokenMetadata[_tokenId].song.audio.lyrics.lyricsNft
        );
        values[33] = artworkUri;
        values[34] = artworkMimeType;
        values[35] = artworkNft;
        values[36] = _getString(
            _tokenMetadata[_tokenId].songPublishingData.releaseDate
        );
        values[37] = _getString(
            _tokenMetadata[_tokenId].songPublishingData.recordLabel
        );
        values[38] = _getString(
            _tokenMetadata[_tokenId].songPublishingData.publisher
        );
        values[39] = _getCollaboratorString(_tokenMetadata[_tokenId]);
        values[40] = artistName;
        values[41] = _getString(_projectMetadata.publishingData.title);
        values[42] = bpm;
        values[43] = songKey;
        values[44] = _getString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQualitative
                .genre
        );
        values[45] = _getString(
            _tokenMetadata[_tokenId].songPublishingData.recordLabel
        );
        values[46] = _getString(
            _tokenMetadata[_tokenId]
                .song
                .audio
                .songDetails
                .audioQualitative
                .license
        );
        return values;
    }
}
