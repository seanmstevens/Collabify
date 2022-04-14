//
//  IdentifiablePFObject.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/14/22.
//

import Parse

class IdentifiablePFObject: PFObject, Identifiable {
    var id = UUID()
}

extension IdentifiablePFObject: PFSubclassing {
    class func parseClassName() -> String {
        return String(describing: Self.self)
    }
}
