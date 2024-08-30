//
//  GFItemInfoView.swift
//  learnuikit
//
//  Created by chuanpham on 30/08/2024.
//

import UIKit

enum ItemInfoType {
    case repos, gists, following, follower
}

class GFItemInfoView: UIView {
    let symbolImageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)
    var itemViews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config() {
        itemViews = [symbolImageView, titleLabel, countLabel]
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        for itemView in itemViews {
            addSubview(itemView)
        }
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint (equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor), 
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
    }
    
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image = UIImage(systemName: SFSymbols.folder)
            titleLabel.text = "Repositories"
        case .gists:
            symbolImageView.image = UIImage(systemName: SFSymbols.gists)
            titleLabel.text = "Gists"
        case .following:
            symbolImageView.image = UIImage(systemName: SFSymbols.following)
            titleLabel.text = "Following"
        case .follower:
            symbolImageView.image = UIImage(systemName: SFSymbols.follower)
            titleLabel.text = "Followers"
        }
        countLabel.text = "\(count)"
    }
}
