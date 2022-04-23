//
//  PlaylistViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Kusch Qin on 4/15/22.
//

import UIKit
import Parse

class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var viewSwitcher: String = "songs"
    
    
    
    @IBOutlet weak var playlistImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var songlistTableView: UITableView!
    
    @IBAction func viewSwitch(_ sender: UISegmentedControl) {
    
        switch sender.selectedSegmentIndex {
        case 0:
            viewSwitcher = "songs"
            self.songlistTableView.reloadData()
        case 1:
            viewSwitcher = "pending"
            self.songlistTableView.reloadData()
        case 2:
            viewSwitcher = "users"
            self.songlistTableView.reloadData()
        default:
            viewSwitcher = "songs"
            self.songlistTableView.reloadData()
        }
    }
    
    
    var playlist: Playlist!
    var songlist: Array<Any>!
    var songs = [Track]()
    var songsP = [Track]()
    var contributors = [PFUser]()

    
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
        
        // find songs with objectId in the track array in the current playlist
        
        var playlistId: String!
        
        playlistId = playlist.objectId ?? ""

//        let query = PFQuery(className: "Playlist")
//        let queryP = PFQuery(className: "Playlist")
//        let queryUsers = PFQuery(className: "Playlist")
//
//        query.whereKey("objectId", equalTo: playlistId)
//        queryP.whereKey("objectId", equalTo: playlistId)
//        queryUsers.whereKey("objectId", equalTo: playlistId)
//
//        query.includeKey("tracks")
//        queryP.includeKey("pendingTracks")
//        queryUsers.includeKey("contributors")
//
//        query.limit = 20
//        queryP.limit = 20
//        queryUsers.limit = 20
//
//        query.findObjectsInBackground { (playlists, error) in
//            if playlists != nil {
//                let playlist = playlists![0] as PFObject
//                self.songs = (playlist["tracks"] as? [PFObject]) ?? []
//
//
//            }
//        }
//        queryP.findObjectsInBackground { (playlistsP, error) in
//            if playlistsP != nil {
//                let playlistP = playlistsP![0] as PFObject
//                self.songsP = (playlistP["pendingTracks"] as? [PFObject]) ?? []
//
//
//            }
//        }
//        queryUsers.findObjectsInBackground { (contributorsList, error) in
//            if contributorsList != nil {
//                let contributors = contributorsList![0] as PFObject
//                self.contributors = (contributorsList["contributors"] as? [PFObject]) ?? []
//
//
//            }
//        }
        
        self.songs = playlist.tracks ?? []
        self.songsP = playlist.pendingTracks ?? []
        self.contributors = playlist.contributors ?? []
        
        self.songlistTableView.reloadData()
        

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (viewSwitcher == "songs") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath as IndexPath) as! SongTableViewCell
            let song = songs[indexPath.row]
            cell.songnameLabel.text = song["title"] as! String
            cell.artistLabel.text = song["artists"] as! String
            if let url = song["imageURL"] {
                cell.songImageView?.af.setImage(withURL: URL(string: url as! String)!, imageTransition: .crossDissolve(0.16))
            }
            return cell
        } else if (viewSwitcher == "pending"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath as IndexPath) as! SongTableViewCell
            let song = songsP[indexPath.row]
            cell.songnameLabel.text = song["title"] as! String
            cell.artistLabel.text = song["artists"] as! String
            if let url = song["imageURL"] {
                cell.songImageView?.af.setImage(withURL: URL(string: url as! String)!, imageTransition: .crossDissolve(0.16))
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath as IndexPath) as! SongTableViewCell
            let user = contributors[indexPath.row]
            cell.songnameLabel.text = user["username"] as! String
            cell.artistLabel.text = user["email"] as? String
            if let url = user["profileImage"] {
                cell.songImageView?.af.setImage(withURL: URL(string: url as! String)!, imageTransition: .crossDissolve(0.16))
            }
            return cell
        }
        
        
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (viewSwitcher == "songs") {
            return songs.count
        } else if (viewSwitcher == "pending") {
            return songsP.count
        } else {
            return contributors.count
        }
        
        return 0 // your number of cells here
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
