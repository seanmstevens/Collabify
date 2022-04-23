//
//  SpotifyAPICaller.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/21/22.
//

import OAuthSwift

class SpotifyAPICaller {
    let baseURL = "https://api.spotify.com/v1"
    let auth: OAuth2Swift
    
    static let shared = SpotifyAPICaller()
    
    fileprivate init() {
        self.auth = OAuth2Swift(
            consumerKey: SPOTIFY_CLIENT_ID,
            consumerSecret: SPOTIFY_CLIENT_SECRET,
            authorizeUrl: "https://accounts.spotify.com/en/authorize",
            accessTokenUrl: "https://accounts.spotify.com/api/token",
            responseType: "code",
            contentType: "application/x-www-form-urlencoded"
        )
        
        doOAuthSpotify()
    }
    
    func doOAuthSpotify() {
        auth.authorize(deviceToken: "code", grantType: "client_credentials") { result in
            switch result {
            case .success:
                print("Successfully authorized!")
            case .failure(let failure):
                print("Failed to authorize: \(failure.underlyingError!.localizedDescription)")
            }
        }
    }
    
    func doSearch(with query: String, using completion: @escaping (Data) -> ()) {
        auth.client.get("\(baseURL)/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&type=track") { result in
            switch result {
            case .success(let response):
                let data = response.data
                completion(data)
            case.failure(let failure):
                print(failure.underlyingError?.localizedDescription as Any)
            }
        }
    }
}
