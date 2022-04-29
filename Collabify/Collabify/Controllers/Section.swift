//
//  Section.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/16/22.
//

//import UIKit
//
//enum SectionEnum: String, CaseIterable {
//    case myPlaylists = "My Playlists"
//    case discover = "Discover"
//}
//
//class Section: Hashable, NSCopying {
//    var id: UUID
//    var title: String
//    var playlists: [Playlist]
//    
//    init(id: UUID, title: String, playlists: [Playlist]) {
//        self.id = id
//        self.title = title
//        self.playlists = playlists
//    }
//    
//    convenience init(title: String, playlists: [Playlist]) {
//        self.init(id: UUID(), title: title, playlists: playlists)
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: Section, rhs: Section) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    func copy(with zone: NSZone? = nil) -> Any {
//        return Section(id: self.id, title: self.title, playlists: self.playlists)
//    }
//}
//
//extension Section {
//    static var allSections: [Section] = SectionEnum.allCases.map {
//        Section(title: $0.rawValue, playlists: [Playlist]())}
//}
