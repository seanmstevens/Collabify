//
//  GenreSearchCell.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/22/22.
//

import UIKit

class GenreSearchCell: UICollectionViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    
    var genre: String! {
        didSet {
            genreLabel.text = genre.capitalized
            contentView.layer.cornerRadius = 8
        }
    }
}
