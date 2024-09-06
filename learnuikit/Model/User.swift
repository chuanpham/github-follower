//
//  User.swift
//  learnuikit
//
//  Created by chuanpham on 20/08/2024.
//

import Foundation

struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var email: String?
    var hireable: Bool?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var followers: Int
    var following: Int
    var createdAt: String
    var htmlUrl: String
}
