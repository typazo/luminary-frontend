//
//  NetworkManager.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import Alamofire
import Foundation

class NetworkManager {

    /// Shared singleton instance
    static let shared = NetworkManager()

    private init() { }

    // MARK: - Requests
    
    func fetchPosts() async throws -> [Post] {
        let endpoint = "placeholder"

        let decoder = JSONDecoder()

        // Create the request
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, method: .get)
                .validate()
                .responseDecodable(of: [Post].self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let posts):
                        print("Successfully fetched \(posts.count) posts")
                        continuation.resume(returning: posts)
                    case .failure(let error):
                        print("Error in NetworkManager.fetchPosts: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchConstellations() async throws -> [Constellation] {
        let endpoint = "placeholder"
        let decoder = JSONDecoder()

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, method: .get)
                .validate()
                .responseDecodable(of: [Constellation].self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let constellations):
                        print("Successfully fetched \(constellations.count) constellations")
                        continuation.resume(returning: constellations)
                    case .failure(let error):
                        print("Error in NetworkManager.fetchConstellations: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchUserStats() async throws -> UserStats {
        let endpoint = "placeholder/user/stats" 
        let decoder = JSONDecoder()

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, method: .get)
                .validate()
                .responseDecodable(of: UserStats.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let stats):
                        print("Successfully fetched user stats")
                        continuation.resume(returning: stats)
                    case .failure(let error):
                        print("Error in NetworkManager.fetchUserStats: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
