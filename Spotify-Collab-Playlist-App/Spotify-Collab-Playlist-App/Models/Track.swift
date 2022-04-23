//
//  Track.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/14/22.
//

import Parse

class Track: IdentifiablePFObject, Decodable {
    @NSManaged var title: String
    @NSManaged var artists: String
    @NSManaged var album: String
    @NSManaged var image: String
    @NSManaged var duration: TimeInterval
    @NSManaged var spotifyID: String
    
    private enum CodingKeys: String, CodingKey {
        case album
        case artists
        case duration = "duration_ms"
        case spotifyID = "id"
        case title = "name"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let artists = try container.decode([Artist].self, forKey: .artists)
        let album = try container.decode(Album.self, forKey: .album)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.artists = artists.map({ artist in
            artist.name
        }).joined(separator: ", ")
        self.album = album.name
        self.image = album.images.first!.url
        self.duration = try container.decode(TimeInterval.self, forKey: .duration)
        self.spotifyID = try container.decode(String.self, forKey: .spotifyID)
    }
}

extension Track: PFSubclassing {
    class func parseClassName() -> String {
        return "Track"
    }
}

extension Track {
    struct Artist: Codable {
        var name: String
    }
    
    private enum ArtistCodingKeys: String, CodingKey {
        case name
    }
}

extension Track {
    struct Album: Codable {
        var name: String
        var images: [Image]
    }
    
    private enum AlbumCodingKeys: String, CodingKey {
        case name
        case images
    }
}

extension Track {
    struct Image: Codable {
        var url: String
    }
    
    private enum ImageCodingKeys: String, CodingKey {
        case url
    }
}

extension Track {
    func getReadableDurationString() -> String? {
        let formatter = DateComponentsFormatter()
        return formatter.string(from: duration)
    }
}
