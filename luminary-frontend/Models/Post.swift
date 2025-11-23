//
//  Post.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import Foundation

struct Post: Hashable, Codable {
    let displayName: String
    let postTime: Date
    let message: String
    let constelationName: String
    let postType: String
    
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
    init(displayName: String, postTime: Date, message: String, constelationName: String, postType: String) {
        self.displayName = displayName
        self.postTime = postTime
        self.message = message
        self.constelationName = constelationName
        self.postType = postType
    }
}





// this is temporary
var dummyData = [
    Post(displayName: "Kalyee", postTime: Date(), message: "bluh", constelationName: "lil dipper", postType: "star"),
    Post(displayName: "Tyler", postTime: Date(), message: "hi", constelationName: "big dipper", postType: "constellation")
]
