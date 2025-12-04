//
//  NetworkManager.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import Alamofire
import Foundation


struct TotalMinutesResponse: Codable {
    let total_minutes: Int
}

struct CompletedConstellationsResponse: Codable {
    let num_completed: Int
}

struct ConstellationAttemptsResponse: Codable {
    let constellation_attempts: [ConstellationAttempt]
}

struct ConstellationAttempt: Codable {
    let stars_completed: Int
}



class NetworkManager {

    /// Shared singleton instance
    static let shared = NetworkManager()
    private let baseURL = "http://136.107.14.97"
    private init() { }

    // MARK: - Requests    
    
    func fetchPosts() async throws -> [Post] {
        let endpoint = "\(baseURL)/api/feed/"
        let decoder = JSONDecoder()

        // Decode wrapper { "posts": [...] }
        struct PostsResponse: Decodable {
            let posts: [Post]
        }

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, method: .get)
                .validate()
                .responseDecodable(of: PostsResponse.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let wrapper):
                        print("Successfully fetched \(wrapper.posts.count) posts")
                        continuation.resume(returning: wrapper.posts)
                    case .failure(let error):
                        print("Error in NetworkManager.fetchPosts: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    
    
    func fetchUserStats(for userId: Int) async throws -> UserStats {
        let decoder = JSONDecoder()

        async let minutesResponse = AF.request("\(baseURL)/api/users/\(userId)/total_minutes/")
            .validate()
            .serializingDecodable(TotalMinutesResponse.self, decoder: decoder)
            .value

        async let completedResponse = AF.request("\(baseURL)/api/users/\(userId)/completed_constellations/")
            .validate()
            .serializingDecodable(CompletedConstellationsResponse.self, decoder: decoder)
            .value

        async let attemptsResponse = AF.request("\(baseURL)/api/users/\(userId)/constellation_attempts/")
            .validate()
            .serializingDecodable(ConstellationAttemptsResponse.self, decoder: decoder)
            .value

        let (minutesData, completedData, attemptsData) = try await (minutesResponse, completedResponse, attemptsResponse)

        let starsCompleted = attemptsData.constellation_attempts.reduce(0) { $0 + $1.stars_completed }
        let constellationsCompleted = completedData.num_completed
        let hoursStudied = minutesData.total_minutes / 60

        return UserStats(starsCompleted: starsCompleted,
                         constellationsCompleted: constellationsCompleted,
                         hoursStudied: hoursStudied)
    }


    
    
    // MARK: - Users API

    func fetchAllUsers() async throws -> [User] {
        let endpoint = "\(baseURL)/api/users/"
        let decoder = JSONDecoder()
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, method: .get)
                .validate()
                .responseDecodable(of: UsersResponse.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let wrapper):
                        continuation.resume(returning: wrapper.users)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    func fetchUser(byID id: Int) async throws -> User {
        let endpoint = "\(baseURL)/api/users/\(id)/"
        let decoder = JSONDecoder()
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, method: .get)
                .validate()
                .responseDecodable(of: User.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let user):
                        continuation.resume(returning: user)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    func createUser(displayName: String) async throws -> User {
        let endpoint = "\(baseURL)/api/users/"
        let decoder = JSONDecoder()
        struct CreateUserBody: Encodable { let display_name: String }
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint,
                       method: .post,
                       parameters: CreateUserBody(display_name: displayName),
                       encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300) // expecting 201
            .responseDecodable(of: User.self, decoder: decoder) { response in
                switch response.result {
                case .success(let user):
                    continuation.resume(returning: user)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func deleteUser(byID id: Int) async throws {
        let endpoint = "\(baseURL)/api/users/\(id)/"
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, method: .delete)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success:
                        print("User deleted successfully")
                        continuation.resume()
                    case .failure(let error):
                        print("Error deleting user: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }


    /// Ensures a user exists on the server and returns it.
    /// Order of resolution:
    /// 1) Local userId → verify via GET /api/users/{id}/
    /// 2) Else GET /api/users/ → match by display_name
    /// 3) Else POST /api/users/
    func ensureUserExists(using settings: UserSettings, fallbackDisplayName: String) async throws -> User {
        // 1) Try stored ID
        if let id = settings.userId {
            do {
                let user = try await fetchUser(byID: id)
                // Optionally refresh display name from server
                settings.userId = user.userId
                settings.displayName = user.displayName
                return user
            } catch {
                // ID invalid server-side → clear and continue
                settings.clear()
            }
        }

        // 2) Try find by display name from settings or fallback
        let desiredName = settings.displayName ?? fallbackDisplayName
        do {
            let users = try await fetchAllUsers()
            if let existing = users.first(where: { $0.displayName == desiredName }) {
                settings.userId = existing.userId
                settings.displayName = existing.displayName
                return existing
            }
        } catch {
            // If listing fails, we still attempt create below
        }

        // 3) Create
        let created = try await createUser(displayName: desiredName)
        settings.userId = created.userId
        settings.displayName = created.displayName
        return created
    }
    
    //THiS IS FOR THE PROFILE PAGE
    func fetchCompletedConstellations(for userId: Int) async throws -> [Constellation] {
        let endpoint = "\(baseURL)/api/users/\(userId)/completed_constellations/"
        let decoder = JSONDecoder()

        struct CompletedConstellationsResponse: Codable {
            let completedConstellations: [Constellation]

            enum CodingKeys: String, CodingKey {
                case completedConstellations = "completed_constellations"
            }
        }

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, method: .get)
                .validate()
                .responseDecodable(of: CompletedConstellationsResponse.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let data):
                        print("Fetched \(data.completedConstellations.count) completed constellations")
                        continuation.resume(returning: data.completedConstellations)
                    case .failure(let error):
                        print("Error fetching completed constellations: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }


}
