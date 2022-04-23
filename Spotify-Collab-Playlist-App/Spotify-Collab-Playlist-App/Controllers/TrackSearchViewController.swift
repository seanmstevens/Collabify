//
//  TrackSearchViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/19/22.
//

import UIKit

class TrackSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchController: UISearchController?
    private var searchResultsController: TrackSearchResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configurationCollectionView()
        
        collectionView.reloadData()
    }
    
    private func configurationCollectionView() {
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            return layout
        }()
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TrackSearchViewController.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreSearchCell.reuseIdentifier, for: indexPath) as? GenreSearchCell else { fatalError("Unable to create genre cell") }
        
        cell.genre = TrackSearchViewController.genres[indexPath.item]
        return cell
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

extension TrackSearchViewController {
    static let genres = ["Rock", "Pop", "Hip-Hop", "Classical", "Country", "Alternative", "Indie", "House", "Dance", "Latin", "R&B", "Metal", "Jazz"]
}
