//
//  PersistenceManager.swift
//  learnuikit
//
//  Created by chuanpham on 4/7/25.
//


import Foundation
import SwiftData

enum PersistenceActionType {
    case add, remove
}

@MainActor
enum PersistenceManager {
    
    static private let context = AppDelegate.sharedContainer.mainContext
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        // First, check if the favorite already exists
        let predicate = #Predicate<Favorite> { $0.login == favorite.login }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            let matches = try context.fetch(descriptor)
            
            switch actionType {
            case .add:
                // If no matches, it's safe to add
                guard matches.isEmpty else {
                    completed(.alreadyInFavorites)
                    return
                }
                let newFavorite = Favorite(follower: favorite)
                context.insert(newFavorite)
                
            case .remove:
                // If there are matches, delete them
                guard !matches.isEmpty else {
                    completed(.unableToFavorite) // Should not happen, but good to guard
                    return
                }
                for match in matches {
                    context.delete(match)
                }
            }
            
            // Save the changes to the database
            try context.save()
            completed(nil) // Success
            
        } catch {
            completed(.unableToFavorite)
        }
    }
    
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        do {
            let fetchDescriptor = FetchDescriptor<Favorite>(sortBy: [SortDescriptor(\.login)])
            let favorites = try context.fetch(fetchDescriptor)
            
            // Convert [Favorite] back to [Follower] for the UI
            let followers = favorites.map { Follower(login: $0.login, avatarUrl: $0.avatarUrl) }
            completed(.success(followers))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
}
