//
//  HomeViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Eyoel Wendwosen on 4/8/22.
//

import UIKit

class HomeViewController: UITableViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    static let sectionHeaderElementKind = "section-header-element-kind"

    enum Section: String, CaseIterable {
      case myPlaylists = "My Playlists"
      case discover = "Discover"
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Playlist>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Playlist>
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func configureLayout() {
        
    }
    
    private func configureCollectionView() {
        
        
        let refreshControl = UIRefreshControl()
        // TODO: Add selector for refreshing behavior
        // refreshControl.addTarget(self, action: nil, for: .valueChanged)
        collectionView.refreshControl = refreshControl
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
