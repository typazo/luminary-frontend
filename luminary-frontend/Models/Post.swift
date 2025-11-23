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
    let constellationName: String
    let postType: String
    let studyDuration: Duration
    
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
    init(displayName: String, postTime: Date, message: String, constellationName: String, postType: String, studyDuration: Duration) {
        self.displayName = displayName
        self.postTime = postTime
        self.message = message
        self.constellationName = constellationName
        self.postType = postType
        self.studyDuration = studyDuration
    }
}





// this is temporary
//could u pls rename this to postdummydata so i can name other things dummydata as well?
var dummyData = [
    Post(displayName: "Kaylee", postTime: Date(timeIntervalSinceReferenceDate: 384678574), message: "bluh", constellationName: "lil dipper", postType: "star", studyDuration: Duration.seconds(61 * 60 + 31)),
    Post(displayName: "Tyler", postTime: Date(timeIntervalSinceReferenceDate: 8921), message: "hi", constellationName: "big dipper", postType: "star", studyDuration: Duration.seconds(10 * 60)),
    Post(displayName: "Lexi", postTime: Date(timeIntervalSinceReferenceDate: 21), message: "glorbizoid", constellationName: "virgo", postType: "constellation", studyDuration: Duration.seconds(10 * 60 + 40))
]
