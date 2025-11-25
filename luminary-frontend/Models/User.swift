//
//  User.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/23/25.
//

import Foundation

struct User : Hashable, Codable {
    let userId: Int //they say "PK" (primary key)
    let displayName: String
    let constellationAttempts: Int
//    let studySessions: [StudySession]
    
    //networking initalizer
//    init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//
//            // Convert string ID to UUID
//            if let idString = try container.decodeIfPresent(String.self, forKey: .id) {
//                self.id = UUID(uuidString: idString)
//            } else {
//                self.id = nil
//            }
//
//            // Decode the rest of the properties normally
//            self.description = try container.decode(String.self, forKey: .description)
//            self.difficulty = try container.decode(String.self, forKey: .difficulty)
//            self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
//            self.name = try container.decode(String.self, forKey: .name)
//            self.rating = try container.decode(Float.self, forKey: .rating)
//    }
    
    //normal initializer
    init(userId: Int, displayName: String, constellationAttempts: Int) {
        self.userId = userId
        self.displayName = displayName
        self.constellationAttempts = constellationAttempts
    }
}


// this is temporary
var userDummyData = [
    User(userId: 0, displayName: "Leem", constellationAttempts: 1),
    User(userId: 0, displayName: "Gary", constellationAttempts: 3)
]
