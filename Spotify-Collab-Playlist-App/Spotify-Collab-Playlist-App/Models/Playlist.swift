//
//  Playlist.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/14/22.
//

import Parse

class Playlist: IdentifiablePFObject {
    @NSManaged var title: String
    @NSManaged var desc: String?
    @NSManaged var image: PFFileObject?
    @NSManaged var contributors: [PFUser]
    @NSManaged var spotifyID: String?
    @NSManaged var tracks: [Track]?
    @NSManaged var isUnderVote: Bool
    @NSManaged var voteCount: Int
}

extension Playlist: PFSubclassing {
    class func parseClassName() -> String {
        return "Playlist"
    }
}
