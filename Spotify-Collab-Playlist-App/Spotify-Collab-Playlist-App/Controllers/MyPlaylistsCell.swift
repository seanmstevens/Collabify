//
//  MyPlaylistsCell.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/14/22.
//

import UIKit
import AlamofireImage

class MyPlaylistsCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contributorsLabel: UILabel!
    
    var playlist: Playlist! {
        didSet {
            titleLabel.text = playlist.title
            contributorsLabel.text = String(playlist.contributors?.count ?? 0) + " contributor" + (playlist.contributors?.count != 1 ? "s" : "")
            imageView.layer.cornerRadius = 12
            
            if let url = playlist.image?.url {
                imageView.af.setImage(withURL: URL(string: url)!, imageTransition: .crossDissolve(0.16))
            }
        }
    }
    
}
