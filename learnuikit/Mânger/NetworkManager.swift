//
//  NetworkManager.swift
//  learnuikit
//
//  Created by chuanpham on 20/08/2024.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "http://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=50&page=\(page)"
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToPerform))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.dataInvalid))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.dataInvalid))
            }
        }
        
        task.resume()
    }
    
    func getUserDetailInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseUrl + "\(username)"
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToPerform))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.dataInvalid))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let userInfo = try decoder.decode(User.self, from: data)
                completed(.success(userInfo))
            } catch {
                completed(.failure(.dataInvalid))
            }
        }
        
        task.resume()
    }
}


