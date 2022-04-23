//
//  HomeViewController.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Eyoel Wendwosen on 4/8/22.
//

import UIKit
import Parse
import Lottie

class HomeViewController: UIViewController, UICollectionViewDelegate {
    enum Section: String, CaseIterable {
        case myPlaylists = "My Playlists"
        case discover = "Discover"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    static let sectionHeaderElementKind = "section-header-element-kind"
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Playlist>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Playlist>
    
    private lazy var dataSource = configureDataSource()
    
    private var myPlaylists = [Playlist]()
    private var filteredMyPlaylists = [Playlist]()
    private var discoverPlaylists = [Playlist]()
    private var filteredDiscoverPlaylists = [Playlist]()
    
    private var playlistsToRetrieve = 20
    private var requestTimestamp: Date? = nil
    
    let searchController = UISearchController(searchResultsController: nil)
    var animationView: AnimationView?
    @IBOutlet weak var profileButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchBar()
        startAnimations()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshFeed()
    }
    
    private func startAnimations() {
        let width: CGFloat = 75, height: CGFloat = 75
        animationView = .init(name: "loader")
        animationView?.frame = CGRect(x: (view.frame.width - width) / 2, y: (view.frame.height - height) / 2, width: width, height: height)
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        
        view.addSubview(animationView!)
        animationView?.play()
    }
    
    private func stopAnimations() {
        animationView?.stop()
        animationView?.removeFromSuperview()
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let sectionType = Section.allCases[indexPath.section]
            
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
                
                cell.playlist = itemIdentifier
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = {(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                fatalError("Unable to create header view")
            }
            
            supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
            return supplementaryView
        }
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.myPlaylists])
        snapshot.appendItems(filteredMyPlaylists, toSection: .myPlaylists)
        
        snapshot.appendSections([.discover])
        snapshot.appendItems(filteredDiscoverPlaylists, toSection: .discover)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = generateLayout()
        collectionView.delegate = self
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            // Return dummy section if there are no elements in the section.
            guard self.dataSource.snapshot().numberOfItems(inSection: Section.allCases[sectionIndex]) > 0 else {
                return self.generateDummySection()
            }
            
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
            
            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .myPlaylists: return self.generateMyPlaylistsLayout(isWide: isWideView, numItems: self.dataSource.snapshot().numberOfItems(inSection: .myPlaylists))
            case .discover: return self.generateDiscoverLayout(isWide: isWideView, numItems: self.dataSource.snapshot().numberOfItems(inSection: .discover))
            }
        }
        
        return layout
    }
    
    private func generateDummySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.01)), subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    private func generateMyPlaylistsLayout(isWide: Bool, numItems: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupFractionalWidth = isWide ? 0.95 / 4 : 0.95 / 2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets.leading = 8
        group.contentInsets.trailing = 8
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        if numItems > 0 { section.boundarySupplementaryItems = [sectionHeader] }
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        return section
    }
    
    private func generateDiscoverLayout(isWide: Bool, numItems: Int) -> NSCollectionLayoutSection {
        let itemFractionalWidth = isWide ? 0.5 : 1.0
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidth), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(itemFractionalWidth / 2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        if numItems > 0 { section.boundarySupplementaryItems = [sectionHeader] }

        return section
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
    @objc private func refreshFeed() {
        retrievePlaylists(since: max(myPlaylists.first?.createdAt ?? Date.distantPast, discoverPlaylists.first?.createdAt ?? Date.distantPast))
    }
    
    private func retrievePlaylists(
        since minTime: Date? = nil,
        until maxTime: Date? = nil,
        animatingDifferences: Bool = true
    ) {
        guard requestTimestamp == nil else { return }
        
        let discoverPlaylistsQuery = Playlist.query()!.includeKeys(["contributors", "tracks"]).order(byDescending: "createdAt")
        let myPlaylistsQuery = Playlist.query()!.includeKeys(["contributors", "tracks"]).order(byDescending: "createdAt")
        discoverPlaylistsQuery.limit = playlistsToRetrieve
        myPlaylistsQuery.limit = playlistsToRetrieve
        
        if let minTime = minTime {
            discoverPlaylistsQuery.whereKey("createdAt", greaterThan: minTime)
            myPlaylistsQuery.whereKey("createdAt", greaterThan: minTime)
        } else if let maxTime = maxTime {
            discoverPlaylistsQuery.whereKey("createdAt", lessThan: maxTime)
            myPlaylistsQuery.whereKey("createdAt", lessThan: maxTime)
        }
        
        discoverPlaylistsQuery.whereKey("contributors", notEqualTo: PFUser.current() as Any)
        myPlaylistsQuery.whereKey("contributors", equalTo: PFUser.current() as Any)
        
        let group = DispatchGroup()
        requestTimestamp = Date()
        
        group.enter()
        discoverPlaylistsQuery.findObjectsInBackground { playlists, error in
            if let error = error {
                print("Error retrieving discover playlists: \(error.localizedDescription)")
            } else if let playlists = playlists as? [Playlist] {
                var insertionPoint = 0

                for playlist in playlists {
                    if minTime != nil {
                        self.discoverPlaylists.insert(playlist, at: insertionPoint)
                        insertionPoint += 1
                    } else {
                        self.discoverPlaylists.append(playlist)
                    }
                }

                self.filteredDiscoverPlaylists = self.discoverPlaylists
            }
            group.leave()
        }
        
        group.enter()
        myPlaylistsQuery.findObjectsInBackground { playlists, error in
            if let error = error {
                print("Error retrieving discover playlists: \(error.localizedDescription)")
            } else if let playlists = playlists as? [Playlist] {
                var insertionPoint = 0

                for playlist in playlists {
                    if minTime != nil {
                        self.myPlaylists.insert(playlist, at: insertionPoint)
                        insertionPoint += 1
                    } else {
                        self.myPlaylists.append(playlist)
                    }
                }

                self.filteredMyPlaylists = self.myPlaylists
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.stopAnimations()
            self.applySnapshot(animatingDifferences: animatingDifferences)
            self.requestTimestamp = nil
            
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    private func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Playlists"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredMyPlaylists = filteredPlaylists(for: myPlaylists, filteringOn: searchController.searchBar.text)
        filteredDiscoverPlaylists = filteredPlaylists(for: discoverPlaylists, filteringOn: searchController.searchBar.text)
        applySnapshot()
    }
    
    private func filteredPlaylists(for playlists: [Playlist], filteringOn query: String?) -> [Playlist] {
        guard let query = query, !query.isEmpty else {
            return playlists
        }
        
        return playlists.filter { $0.contains(query: query) }
    }
}

extension Bundle {
  
  var icon: UIImage? {
    
    if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
       let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
       let files = primary["CFBundleIconFiles"] as? [String],
       let icon = files.last
    {
      return UIImage(named: icon)
    }
    
    return nil
  }
}
