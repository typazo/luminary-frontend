//
//  Constellation.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/23/25.
//

import Foundation

struct Constellation: Hashable, Codable {
    let name: String
    let constellationId: Int
    let weight: Int
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case constellationId = "id"
        case weight
    }

    init(name: String, constellationId: Int, weight: Int) {
        self.name = name
        self.constellationId = constellationId
        self.weight = weight
    }

    
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
}





// this is temporary
var constellationDummyData = [
    Constellation(name: "Cassiopeia", constellationId: 0, weight: 3),
    Constellation(name: "Ursa Major", constellationId: 1, weight: 5),
    Constellation(name: "Pyxis", constellationId: 2, weight: 8)
]
