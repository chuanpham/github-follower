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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        usernameLabel.text = follower.login
        avatarImgView.downloadImage(from: follower.avatarUrl)
    }
    
    private func config() {
        addSubview(avatarImgView)
        addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
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
