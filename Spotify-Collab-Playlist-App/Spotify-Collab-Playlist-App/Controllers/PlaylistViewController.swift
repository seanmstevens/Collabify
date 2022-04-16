//
//  PlaylistViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Kusch Qin on 4/15/22.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    var playlist: Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(playlist["title"])
        // Do any additional setup after loading the view.
        
        
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
