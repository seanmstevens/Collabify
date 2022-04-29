//
//  PFObject+RelativeDateTime.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/14/22.
//

import Parse

extension PFObject {
    func getRelativeDateTimeString(for date: Date?) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .full
        
        return formatter.localizedString(for: date ?? Date(), relativeTo: Date())
    }
}
