//
//  User.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/23/25.
//

import Foundation

struct User : Hashable, Codable {
//    let userId: Int //they say "PK" (primary key)
//    let displayName: String
//    let constellationAttempts: Int\
    
    let userId: Int            // maps from "id"
    let displayName: String    // maps from "display_name"
    let constellationAttempts: Int

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case constellationAttempts = "constellation_attempts"
    }

    init(userId: Int, displayName: String, constellationAttempts: Int) {
        self.userId = userId
        self.displayName = displayName
        self.constellationAttempts = constellationAttempts
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .displayName)

        // The API returns `constellation_attempts` as an array → we count it
        let attemptsArray = (try? container.decode([ConstellationAttemptStub].self, forKey: .constellationAttempts)) ?? []
        self.init(userId: id, displayName: name, constellationAttempts: attemptsArray.count)
    }

    // Minimal stub to count attempts; expand later if you need details
    private struct ConstellationAttemptStub: Codable {
        let id: Int
        let user_id: Int
        let constellation_id: Int
        let stars_completed: Int
    }
}

    
// Wrapper for GET /api/users/ (returns { "users": [...] })
struct UsersResponse: Codable {
    let users: [User]
}


// this is temporary
var userDummyData = [
    User(userId: 0, displayName: "Leem", constellationAttempts: 1),
    User(userId: 0, displayName: "Gary", constellationAttempts: 3)
]
