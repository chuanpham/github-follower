//
//  GFRepoItemVC.swift
//  learnuikit
//
//  Created by chuanpham on 30/08/2024.
//

import Foundation

class GFRepoItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
    }
    
    func configItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}
