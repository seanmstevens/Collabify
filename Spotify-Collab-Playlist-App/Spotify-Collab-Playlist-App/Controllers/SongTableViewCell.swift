//
//  SongTableViewCell.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Kusch Qin on 4/16/22.
//

import UIKit
import Parse
import AlamofireImage

class SongTableViewCell: UITableViewCell {

    
    @IBOutlet weak var songImageView: UIImageView!

    @IBOutlet weak var songnameLabel: UILabel!

    @IBOutlet weak var artistLabel: UILabel!
    
    var song: Track! {
        didSet {
            songnameLabel.text = song.title
            artistLabel.text = song.artists
//            imageView.layer.cornerRadius = 12
            
            if let url = song.imageURL?.url {
                imageView?.af.setImage(withURL: URL(string: url)!, imageTransition: .crossDissolve(0.16))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
