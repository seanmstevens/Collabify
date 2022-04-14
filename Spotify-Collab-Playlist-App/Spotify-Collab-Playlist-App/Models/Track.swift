//
//  Track.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/14/22.
//

import Parse

class Track: IdentifiablePFObject {
    @NSManaged var title: String
    @NSManaged var artists: String
    @NSManaged var album: String
    @NSManaged var image: URL
    @NSManaged var duration: TimeInterval
    @NSManaged var spotifyID: String
}
