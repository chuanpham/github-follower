//
//  Favorite.swift
//  learnuikit
//
//  Created by chuanpham on 4/7/25.
//

import Foundation
import SwiftData

@Model
class Favorite {
    // Storing the login as a unique ID
    @Attribute(.unique) var login: String
    var avatarUrl: String
    
    init(follower: Follower) {
        self.login = follower.login
        self.avatarUrl = follower.avatarUrl
    }
}
