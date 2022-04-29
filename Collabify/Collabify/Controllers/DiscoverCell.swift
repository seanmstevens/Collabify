//
//  DiscoverCell.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/14/22.
//

import UIKit
import AlamofireImage

class DiscoverCell: UICollectionViewCell {
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var playlistDescriptionLabel: UILabel!
    
    var playlist: Playlist! {
        didSet {
            playlistTitleLabel.text = playlist.title
            updatedTimeLabel.text = "Updated " + playlist.getRelativeDateTimeString(for: playlist.updatedAt)
            playlistDescriptionLabel.text = playlist.desc
            layer.cornerRadius = 12
            
            if let url = playlist.image?.url {
                playlistImageView.contentMode = .scaleAspectFill
                playlistImageView.af.setImage(withURL: URL(string: url)!, placeholderImage: .init(named: "playlist-placeholder"), imageTransition: .crossDissolve(0.16))
            }
        }
    }
}
