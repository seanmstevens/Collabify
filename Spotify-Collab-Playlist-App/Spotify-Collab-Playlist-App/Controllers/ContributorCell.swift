//
//  ContributorCell.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/23/22.
//

import UIKit
import Parse
import AlamofireImage

class ContributorCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: PFUser! {
        didSet {
            usernameLabel.text = user.username
            emailLabel.text = user.getRelativeDateTimeString(for: user.createdAt)
            userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
            
            if let imageFile = user["profileImage"] as? PFFileObject, let url = URL(string: imageFile.url!) {
                userProfileImageView.af.setImage(withURL: url, placeholderImage: .init(systemName: "person.circle.fill"), imageTransition: .crossDissolve(0.16))
            }
        }
    }
}
