//
//  PlaylistViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Kusch Qin on 4/15/22.
//
import UIKit
import AlamofireImage
import Parse

class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    enum Segments: String, CaseIterable {
        case songs
        case pending
        case contributors
    }
    
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var songlistTableView: UITableView!
    @IBOutlet weak var segmentedSelector: UISegmentedControl!
    
    
    var playlist: Playlist!
    var songs = [Track]()
    var songsP = [Track]()
    var contributors = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = playlist.title
        descriptionLabel.text = playlist.desc
        if let url = URL(string: (playlist.image?.url)!) {
            playlistImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.16))
        }
        
        songlistTableView.delegate = self
        songlistTableView.dataSource = self
        
        self.songs = playlist.tracks ?? []
        self.songsP = playlist.pendingTracks ?? []
        self.contributors = playlist.contributors ?? []
        
        self.songlistTableView.reloadData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPlaylist), for: .valueChanged)
        songlistTableView.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPlaylist), name: NSNotification.Name("TrackSelected"), object: nil)
    }
    
    @objc func refreshPlaylist() {
        self.playlist.fetchInBackground { object, error in
            if let error = error {
                print("Error when refreshing the playlist data: \(error.localizedDescription)")
            } else if let playlist = object as? Playlist {
                self.playlist = playlist
                self.songs = playlist.tracks ?? []
                self.songsP = playlist.pendingTracks ?? []
                self.contributors = playlist.contributors ?? []
                
                self.songlistTableView.reloadData()
                self.songlistTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let segment = Segments.allCases[segmentedSelector.selectedSegmentIndex]
        
        switch segment {
        case .songs:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath as IndexPath) as! SongTableViewCell
            let song = songs[indexPath.row]
            
            cell.song = song
            return cell
        case .pending:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath as IndexPath) as! SongTableViewCell
            let song = songsP[indexPath.row]
            
            cell.song = song
            return cell
        case .contributors:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContributorCell", for: indexPath as IndexPath) as! ContributorCell
            let user = contributors[indexPath.row]
            
            cell.user = user
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let segment = Segments.allCases[segmentedSelector.selectedSegmentIndex]
        
        switch segment {
        case .songs: return songs.count
        case .pending: return songsP.count
        case .contributors: return contributors.count
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let nav = segue.destination as? UINavigationController, let destination = nav.topViewController as? TrackSearchViewController {
            destination.playlist = playlist
        }
    }
    
    @IBAction func onSegmentChange(_ sender: Any) {
        songlistTableView.reloadData()
    }
    
    @IBAction func unwindToPlaylistViewController(segue: UIStoryboardSegue) {}
}
