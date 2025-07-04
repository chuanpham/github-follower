//
//  FollowerCell.swift
//  learnuikit
//
//  Created by chuanpham on 20/08/2024.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let reuseID = "FollowerCell"
    
    
    let avatarImgView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    let favoriteButton = UIButton()
    
    var onFavoriteButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower, isFavorite: Bool) {
        usernameLabel.text = follower.login
        avatarImgView.downloadImage(from: follower.avatarUrl)
        updateFavoriteButton(isFavorite: isFavorite)
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        let heartImageName = isFavorite ? "heart.fill" : "heart"
        let heartColor = isFavorite ? UIColor.systemRed : UIColor.systemGray2
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        
        favoriteButton.setImage(UIImage(systemName: heartImageName, withConfiguration: config), for: .normal)
        favoriteButton.tintColor = heartColor
    }
    
    @objc private func favoriteButtonTapped() {
        // Animate the button for visual feedback
        UIView.animate(withDuration: 0.1, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) { self.favoriteButton.transform = .identity }
        }
        // Call the closure to notify the view controller
        onFavoriteButtonTapped?()
    }
    
    private func config() {
        contentView.addSubview(avatarImgView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(favoriteButton)
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            
            avatarImgView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            avatarImgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            avatarImgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            avatarImgView.heightAnchor.constraint(equalTo: avatarImgView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImgView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
