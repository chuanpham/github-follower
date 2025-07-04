//
//  FavoritesListVC.swift
//  learnuikit
//
//  Created by chuanpham on 16/08/2024.
//

import UIKit

class FavoritesListVC: UIViewController {
    
    enum Section { case main }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    var favorites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func getFavorites() {
        self.showLoadingView()
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.dismissLoadingView()
        }
    }
    
    func updateUI(with favorites: [Follower]) {
        // If the list is empty, show the empty state.
        if favorites.isEmpty {
            // Important: Make sure to remove any existing empty state view before showing a new one.
            DispatchQueue.main.async {
                self.view.subviews.first(where: { $0 is GFEmptyStateView })?.removeFromSuperview()
                self.showEmptyStateView(with: "No Favorites?\nAdd one from the follower screen.", in: self.view)
            }
        } else {
            // If there are favorites, remove the empty state view if it exists.
            DispatchQueue.main.async {
                self.view.subviews.first(where: { $0 is GFEmptyStateView })?.removeFromSuperview()
            }
        }
        
        self.favorites = favorites
        self.updateData(on: self.favorites)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FollowerCell, Follower> { [weak self] (cell, indexPath, follower) in
            guard let self = self else { return }
            
            // Since this is the favorites list, all are favorited.
            cell.set(follower: follower, isFavorite: true)
            
            // Set the closure for the favorite button tap.
            cell.onFavoriteButtonTapped = {
                self.handleUnfavorite(follower: follower)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView) {
            (collectionView, indexPath, follower) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: follower)
        }
    }
    
    // This method handles the logic for removing a favorite.
    private func handleUnfavorite(follower: Follower) {
        PersistenceManager.updateWith(favorite: follower, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            if let error {
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "OK")
                return
            }
            
            // Refetch the favorites to update the UI.
            self.getFavorites()
        }
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
