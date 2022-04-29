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
    var playlist: Playlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configurationCollectionView()
        collectionView.reloadData()
    }
    
    private func configurationCollectionView() {
        collectionView.collectionViewLayout = generateLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let fraction: CGFloat = 1/2
        let inset: CGFloat = 6
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        return UICollectionViewCompositionalLayout(section: section)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchController?.isActive = true
        searchController?.searchBar.text = "genre:\(TrackSearchViewController.genres[indexPath.item].lowercased())"
    }
}

extension TrackSearchViewController {
    private func configureSearchBar() {
        searchResultsController = (storyboard?.instantiateViewController(withIdentifier: "TrackSearchResultsController") as! TrackSearchResultsController)
        searchResultsController.playlist = playlist
        
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
