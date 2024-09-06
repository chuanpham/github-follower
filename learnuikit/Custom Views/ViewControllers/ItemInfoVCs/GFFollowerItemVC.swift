//
//  GFFollowerItemVC.swift
//  learnuikit
//
//  Created by chuanpham on 30/08/2024.
//

import Foundation

class GFFollowerItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }
    
    func configItems() {
        itemInfoViewOne.set(itemInfoType: .follower, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "GitHub Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollower(for: user)
    }
}
