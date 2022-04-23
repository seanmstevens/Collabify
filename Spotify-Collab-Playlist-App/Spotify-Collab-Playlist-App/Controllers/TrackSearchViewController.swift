//
//  TrackSearchViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/19/22.
//

import UIKit

class TrackSearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchController: UISearchController?
    private var searchResultsController: TrackSearchResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
    }
    
    
}

extension TrackSearchViewController {
    private func configureSearchBar() {
        searchResultsController = (storyboard?.instantiateViewController(withIdentifier: "TrackSearchResultsController") as! TrackSearchResultsController)
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController?.searchResultsUpdater = searchResultsController
        searchController?.obscuresBackgroundDuringPresentation = true
        searchController?.searchBar.placeholder = "Search Tracks"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
