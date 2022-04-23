//
//  TrackSearchResultsCell.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/22/22.
//

import UIKit
import AlamofireImage

class TrackSearchResultsCell: UICollectionViewCell {
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackArtistLabel: UILabel!
    @IBOutlet weak var trackAlbumLabel: UILabel!
    
    var track: Track! {
        didSet {
            trackTitleLabel.text = track.title
            trackArtistLabel.text = track.artists
            trackAlbumLabel.text = track.album
            trackImageView.layer.cornerRadius = 8
            
            let url = URL(string: track.image)!
            trackImageView.af.setImage(withURL: url, placeholderImage: .init(named: "playlist-placeholder"), imageTransition: .crossDissolve(0.16))
        }
    }
}
