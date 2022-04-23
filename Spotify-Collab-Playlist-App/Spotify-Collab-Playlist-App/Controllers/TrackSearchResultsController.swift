//
//  TrackSearchResultsController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/22/22.
//

import UIKit

class TrackSearchResultsController: UICollectionViewController {
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Track>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Track>
    
    private lazy var dataSource = configureDataSource()
    
    var searchTask: DispatchWorkItem?
    let delayInSeconds = 0.5
    
    var filteredTracks = [Track]()
    var playlist: Playlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackSearchResultsCell.reuseIdentifier, for: indexPath) as? TrackSearchResultsCell else {
                fatalError("Unable to create new cell")
            }
                
            cell.track = itemIdentifier
            return cell
        }
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        if filteredTracks.isEmpty {
            collectionView.setEmptyMessage("No results matching search query")
        } else {
            collectionView.restoreBackground()
        }
        
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredTracks, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func configureCollectionView() {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let playlist = playlist {
            collectionView.isUserInteractionEnabled = false
            let track = filteredTracks[indexPath.item]
            playlist.addUniqueObject(track, forKey: "tracks")
            
            playlist.saveInBackground { success, error in
                if let error = error {
                    print("Unable to save track to playlist: \(error.localizedDescription)")
                } else if success {
                    print("Saved track to playlist!")
                }
                
                collectionView.isUserInteractionEnabled = true
            }
        }
    }
}

extension TrackSearchResultsController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else { return }
        searchTask?.cancel()
        
        // Debouncing requests to prevent redundant requests to API. Code adapted from:
        // https://blog.tarkalabs.com/all-about-debounce-4-ways-to-achieve-debounce-in-swift-e8f8ce22f544
        let task = DispatchWorkItem { [weak self] in
            DispatchQueue.global(qos: .userInteractive).async {
                SpotifyAPICaller.shared.doSearch(with: query) { data in
                    let decoder = JSONDecoder()

                    if let tracksData = try? decoder.decode(RawServerResponse.self, from: data) {
                        self?.filteredTracks = tracksData.tracks
                        self?.applySnapshot(animatingDifferences: false)
                    }
                }
            }
        }
        
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds, execute: task)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredTracks.removeAll()
        applySnapshot()
    }
}

extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 17, weight: .medium)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restoreBackground() {
        self.backgroundView = nil
    }
}
