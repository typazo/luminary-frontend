//
//  Post.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import Foundation

//struct Post: Hashable, Codable {
//    let displayName: String
//    let postTime: Date
//    let message: String
//    let constellationName: String
//    let postType: String
//    let studyDuration: Duration
//
//
//    //normal initializer
//    init(displayName: String, postTime: Date, message: String, constellationName: String, postType: String, studyDuration: Duration) {
//        self.displayName = displayName
//        self.postTime = postTime
//        self.message = message
//        self.constellationName = constellationName
//        self.postType = postType
//        self.studyDuration = studyDuration
//    }
//}




import Foundation

struct Post: Hashable, Codable {
    let displayName: String
    let postTime: Date
    let message: String        // Default empty string
    let constellationName: String
    let postType: String
    let studyDuration: Duration // Default zero duration

    enum CodingKeys: String, CodingKey {
        case postType = "post_type"
        case createdAt = "created_at"
        case user
        case constellation
    }

    enum UserKeys: String, CodingKey {
        case displayName = "display_name"
    }

    enum ConstellationKeys: String, CodingKey {
        case name
    }

    // MARK: - Custom Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        postType = (try? container.decode(String.self, forKey: .postType)) ?? "unknown"

        let createdAtString = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
        let formatter = ISO8601DateFormatter()
        postTime = formatter.date(from: createdAtString) ?? Date()

        let userContainer = try container.nestedContainer(keyedBy: UserKeys.self, forKey: .user)
        displayName = (try? userContainer.decode(String.self, forKey: .displayName)) ?? "Anonymous"

        let constellationContainer = try container.nestedContainer(keyedBy: ConstellationKeys.self, forKey: .constellation)
        constellationName = (try? constellationContainer.decode(String.self, forKey: .name)) ?? "Unknown"

        message = "" // Default
        studyDuration = .seconds(0) // Default
    }

    // MARK: - Custom Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(postType, forKey: .postType)
        try container.encode(ISO8601DateFormatter().string(from: postTime), forKey: .createdAt)

        var userContainer = container.nestedContainer(keyedBy: UserKeys.self, forKey: .user)
        try userContainer.encode(displayName, forKey: .displayName)

        var constellationContainer = container.nestedContainer(keyedBy: ConstellationKeys.self, forKey: .constellation)
        try constellationContainer.encode(constellationName, forKey: .name)
    }
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
