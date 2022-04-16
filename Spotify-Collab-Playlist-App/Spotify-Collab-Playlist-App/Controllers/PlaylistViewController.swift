//
//  PlaylistViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Kusch Qin on 4/15/22.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var playlistImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var playlist: Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = playlist["title"] as? String
        descriptionLabel.text = playlist["desc"] as? String
        if let url = playlist.image?.url {
            playlistImageView.af.setImage(withURL: URL(string: url)!, imageTransition: .crossDissolve(0.16))
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
