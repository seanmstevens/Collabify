//
//  SongTableViewCell.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Kusch Qin on 4/16/22.
//
import UIKit
import AlamofireImage

class SongTableViewCell: UITableViewCell {
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songnameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var song: Track! {
        didSet {
            songnameLabel.text = song.title
            artistLabel.text = song.artists
            songImageView.layer.cornerRadius = 8
            
            if let url = URL(string: song.image) {
                songImageView.af.setImage(withURL: url, placeholderImage: .init(named: "playlist-placeholder"), imageTransition: .crossDissolve(0.16))
            }
        }
    }
}
