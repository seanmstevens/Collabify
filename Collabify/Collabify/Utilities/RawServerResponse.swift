//
//  RawServerResponse.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/22/22.
//

import Foundation

// Utility struct used to decode responses from Spotify API search calls
// https://stackoverflow.com/questions/44549310/how-to-decode-a-nested-json-struct-with-swift-decodable-protocol
struct RawServerResponse: Decodable {
    enum RootKey: String, CodingKey {
        case tracks
    }
    
    enum NestedKeys: String, CodingKey {
        case items
    }
    
    let tracks: [Track]
}

extension RawServerResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let items = try container.nestedContainer(keyedBy: NestedKeys.self, forKey: .tracks)
        
        self.tracks = try items.decode([Track].self, forKey: .items)
    }
}
