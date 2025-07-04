//
//  FollowerListVC.swift
//  learnuikit
//
//  Created by chuanpham on 19/08/2024.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func reload(for username: String)
}

class FollowerListVC: UIViewController {
    
    enum Section { case main }
    
    var username: String!
    var followers: [Follower] = []
    var filterFollowers: [Follower] = []
    var page = 1
    var hasMore = true
    var isSearching = false
    var isLoading = false
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewController()
        configCollectionView()
        configDataSource()
        configSearchController()
        configRefreshControl()
        getFollowers(username: username, page: page)
    }
    
    func configRefreshControl() {
        refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl // Assign it to the collection view
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    func getFollowers(username: String, page: Int, isRefresh: Bool = false) {
        guard !isLoading else { return } // Prevent multiple simultaneous loads
        
        // Only show the full-screen loader on the initial load, not on a refresh
        if page == 1 && !isRefresh {
            showLoadingView()
        } else {
            // For subsequent pages, ensure the footer indicator will show
            isLoading = true
            DispatchQueue.main.async {
                self.updateData(from: self.followers)
            }
            
        }
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.refreshControl.endRefreshing()
                
                self.isLoading = false
                if page == 1 && !isRefresh {
                    self.dismissLoadingView()
                }
            }
                
                switch result {
                case .success(let followers):
                    if followers.count < 20 { self.hasMore = false }
                    self.followers.append(contentsOf: followers)
                    if self.followers.isEmpty {
                        DispatchQueue.main.async {
                            self.showEmptyStateView(with: "Sorry, no data!", in: self.view)
                        }
                        self.isLoading = false
                        return
                    }
                    self.isLoading = false
                    self.updateData(from: self.followers)
                case .failure(let error):
                    isLoading = false
                    self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
                }
            }
        }
        
        func configDataSource() {
            let cellRegistration = UICollectionView.CellRegistration<FollowerCell, Follower> { (cell, indexPath, follower) in
                cell.set(follower: follower)
            }
            
            dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView) {
                (collectionView, indexPath, follower) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: follower)
            }
            
            let footerRegistration = UICollectionView.SupplementaryRegistration<LoadingFooterView>(elementKind: UICollectionView.elementKindSectionFooter) { [weak self]
                (supplementaryView, string, indexPath) in
                supplementaryView.toggleLoading(self?.isLoading ?? false)
            }
            
            dataSource.supplementaryViewProvider = { [weak self] (view, kind, index) in
                return self?.collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: index)
            }
        }
        
        func updateData(from data: [Follower]) {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
            snapshot.appendSections([.main])
            snapshot.appendItems(data)
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    extension FollowerListVC: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            guard !isSearching, hasMore else { return }
            
            if indexPath.item == followers.count - 1 {
                page += 1
                getFollowers(username: username, page: page)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let activeList = isSearching ? filterFollowers : followers
            let follower = activeList[indexPath.item]
            
            // Modal bottom sheet
            let destinationVC = UserInfoVC()
            destinationVC.delegate = self
            destinationVC.follower = follower
            let navController = UINavigationController(rootViewController: destinationVC)
            present(navController, animated: true)
        }
    }
    
    extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
        func updateSearchResults(for searchController: UISearchController) {
            guard let filter = searchController.searchBar.text, !filter.isEmpty else {
                // When the filter is cleared, show the original followers
                isSearching = false
                updateData(from: followers)
                return
            }
            isSearching = true // Explicitly set to true
            filterFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
            updateData(from: filterFollowers)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            isSearching = false // Explicitly set to false
            updateData(from: followers)
        }
    }
    
    extension FollowerListVC: FollowerListVCDelegate {
        func reload(for username: String) {
            self.username = username
            self.title = username
            followers = []
            filterFollowers = []
            page = 1
            hasMore = true
            isSearching = false
            collectionView.setContentOffset(.zero, animated: true)
            getFollowers(username: username, page: page)
        }
    }
    
    extension FollowerListVC {
        
        @objc private func handleRefresh() {
            // Ensure we don't have stale data from a search
            guard !isSearching else {
                refreshControl.endRefreshing()
                return
            }
            
            // Reset everything to its initial state
            followers = []
            filterFollowers = []
            page = 1
            hasMore = true
            isSearching = false
            
            // Fetch the first page of followers again
            getFollowers(username: username, page: page, isRefresh: true)
        }
    }
    
    class LoadingFooterView: UICollectionReusableView {
        static let reuseIdentifier = "loading-footer-reuse-identifier"
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configure() {
            addSubview(activityIndicator)
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            activityIndicator.style = .large
            
            activityIndicator.color = .systemGray
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        func toggleLoading(_ isLoading: Bool) {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
