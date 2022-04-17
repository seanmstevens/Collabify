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
    
    func contains(query: String?) -> Bool {
        guard let query = query, !query.isEmpty else {
            return true
        }

        return title.range(of: query, options: .caseInsensitive) != nil || desc?.range(of: query, options: .caseInsensitive) != nil
    }
}

extension Playlist: PFSubclassing {
    class func parseClassName() -> String {
        return "Playlist"
    }
}
