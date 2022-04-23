//
//  PlaylistViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Kusch Qin on 4/15/22.
//

import UIKit
import Parse

class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    
    @IBOutlet weak var playlistImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var songlistTableView: UITableView!
    
    
    var playlist: Playlist!
    var songlist: Array<Any>!
    var songs = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = playlist["title"] as? String
        descriptionLabel.text = playlist["desc"] as? String
        if let url = playlist.image?.url {
            playlistImageView.af.setImage(withURL: URL(string: url)!, imageTransition: .crossDissolve(0.16))
        }
        songlistTableView.delegate = self
        songlistTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let query = PFQuery(className: "Track")
//        query.includeKey("artists")
//        query.limit = 20
//
//        query.findObjectsInBackground { (song, error) in
//            if song != nil {
//                self.song = song!
//                self.songlistTableView.reloadData()
//
//            }
//        }
        songlist = playlist.tracks
        print(songlist)
        
        self.songlistTableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath as IndexPath) as! SongTableViewCell
        
        let song = songs[indexPath.row]
        cell.song = song
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count // your number of cells here
        }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // your cell coding
        let cell = UITableViewCell()
        return cell
    }

    func tableView(songlistTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
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
