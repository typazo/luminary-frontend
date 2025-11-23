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
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let endpoint = "placeholder"

        let decoder = JSONDecoder()

        // Create the request
        AF.request(endpoint, method: .get)
            .validate()
            .responseDecodable(of: [Post].self, decoder: decoder) { response in
                // Handle the response
                switch response.result {
                case .success(let posts):
                    print("Successfully fetched \(posts.count) posts")
                    completion(.success(posts))
                case .failure(let error):
                    print("Error in NetworkManager.fetchPosts: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    func fetchConstellations(completion: @escaping (Result<[Constellation], Error>) -> Void) {
        let endpoint = "placeholder"

        let decoder = JSONDecoder()

        // Create the request
        AF.request(endpoint, method: .get)
            .validate()
            .responseDecodable(of: [Constellation].self, decoder: decoder) { response in
                // Handle the response
                switch response.result {
                case .success(let constellations):
                    print("Successfully fetched \(constellations.count) constellations")
                    completion(.success(constellations))
                case .failure(let error):
                    print("Error in NetworkManager.fetchPosts: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
