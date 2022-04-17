//
//  HomeViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Eyoel Wendwosen on 4/8/22.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UICollectionViewDelegate, UISearchResultsUpdating {
    @IBOutlet weak var collectionView: UICollectionView!

    static let sectionHeaderElementKind = "section-header-element-kind"
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Playlist>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Playlist>
    
    private lazy var dataSource = configureDataSource()
    
    private var sections = Section.allSections
    private var filteredSections = Section.allSections
    var playlistsToRetrieve = 20
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Playlists"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshFeed()
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let sectionType = SectionEnum.allCases[indexPath.section]
            
            switch sectionType {
            case .myPlaylists:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPlaylistsCell.reuseIdentifier, for: indexPath) as? MyPlaylistsCell else {
                    fatalError("Unable to create new cell")
                }
                
                cell.playlist = itemIdentifier
                return cell
            case .discover:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCell.reuseIdentifier, for: indexPath) as? DiscoverCell else {
                    fatalError("Unable to create new cell")
                }
                
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = {(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                fatalError("Unable to create header view")
            }
            
            supplementaryView.label.text = SectionEnum.allCases[indexPath.section].rawValue
            return supplementaryView
        }
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections(filteredSections)
        filteredSections.forEach { section in
            snapshot.appendItems(section.playlists, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = generateLayout()
        collectionView.delegate = self
//        collectionView.register(MyPlaylistsCell.self, forCellWithReuseIdentifier: MyPlaylistsCell.reuseIdentifier)
//        collectionView.register(DiscoverCell.self, forCellWithReuseIdentifier: DiscoverCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        // TODO: Add selector for refreshing behavior
        // refreshControl.addTarget(self, action: nil, for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
            
            let sectionLayoutKind = SectionEnum.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .myPlaylists: return self.generateMyPlaylistsLayout(isWide: isWideView)
            case .discover: return self.generateDiscoverLayout(isWide: isWideView)
            }
        }
        
        return layout
    }
    
    private func generateMyPlaylistsLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupFractionalWidth = isWide ? 1.0 / 4 : 1.0 / 2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets.leading = 8
        group.contentInsets.trailing = 8
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func generateDiscoverLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(186))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 8)

        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: HomeViewController.sectionHeaderElementKind,
          alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredSections = filteredSections(for: searchController.searchBar.text)
        applySnapshot()
    }
    
    private func filteredSections(for query: String?) -> [Section] {
        let sections = sections.map { $0.copy() as! Section }
        
        guard let query = query, !query.isEmpty else {
            return sections
        }
        
        for section in sections {
            section.playlists = section.playlists.filter { $0.contains(query: query) }
        }
        
        return sections.filter { !$0.playlists.isEmpty }
        
        
//        return sections.filter { section in
//            var matches = section.title.range(of: query, options: .caseInsensitive) != nil
//
//            for playlist in section.playlists {
//                if playlist.title.range(of: query, options: .caseInsensitive) != nil {
//                    matches = true
//                    break
//                }
//            }
//
//            return matches
//        }
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

extension HomeViewController {
    @objc func refreshFeed() {
        retrievePlaylists()
    }
    
    private func retrievePlaylists(animatingDifferences: Bool = true) {
        let query = Playlist.query()!
        query.includeKeys(["contributors", "tracks"])
        query.limit = playlistsToRetrieve
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { playlists, error in
            if let error = error {
                print("Error retrieving playlists: \(error.localizedDescription)")
            } else if let playlists = playlists as? [Playlist] {
                var insertionPoint = 0
                
                for playlist in playlists {
                    self.sections[0].playlists.append(playlist)
                }
                
                self.filteredSections = self.sections
                self.applySnapshot()
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
        
//        query.whereKey("contributors", equalTo: PFUser.current())
//        query.findObjectsInBackground { playlists, error in
//            if let error = error {
//                print("Error retrieving my playlists: \(error.localizedDescription)")
//            } else if let playlists = playlists as? [Playlist] {
//                var insertionPoint = 0
//
//                for playlist in playlists {
//                    self.playlists.append(playlist)
//                }
//
//                self.applySnapshot()
//                self.collectionView.refreshControl?.endRefreshing()
//            }
//        }
    }
}
