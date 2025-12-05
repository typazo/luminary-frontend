//
//  Post.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import Foundation

import Foundation

struct Post: Hashable, Codable {
    let id: Int
    let userId: Int
    let constellationId: Int
    let displayName: String
    let postTime: Date
    let message: String          // non-optional, defaults to ""
    let constellationName: String
    let postType: String
    let studyDuration: Duration  // non-optional, defaults to 0 seconds

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case constellationId = "constellation_id"
        case postType = "post_type"
        case message
        case studyDuration = "study_duration" // minutes in API
        case createdAt = "created_at"
        case user
        case constellation
    }

    enum UserKeys: String, CodingKey {
        case id
        case displayName = "display_name"
    }

    enum ConstellationKeys: String, CodingKey {
        case id
        case name
        case weight
    }

    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        self.userId = (try? container.decode(Int.self, forKey: .userId)) ?? -1
        self.constellationId = (try? container.decode(Int.self, forKey: .constellationId)) ?? -1

        self.postType = (try? container.decode(String.self, forKey: .postType)) ?? "unknown"
        self.message = (try? container.decode(String.self, forKey: .message)) ?? ""

        // created_at → Date (robust parser that handles with/without timezone)
        let createdAtString = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
        self.postTime = Post.parseDate(createdAtString) ?? Date()

        // study_duration (minutes) → Duration (seconds)
        if let minutes = try? container.decode(Int.self, forKey: .studyDuration) {
            self.studyDuration = .seconds(minutes * 60)
        } else {
            self.studyDuration = .seconds(0)
        }

        // Nested user
        if container.contains(.user) {
            let userContainer = try container.nestedContainer(keyedBy: UserKeys.self, forKey: .user)
            self.displayName = (try? userContainer.decode(String.self, forKey: .displayName)) ?? "Anonymous"
        } else {
            self.displayName = "Anonymous"
        }

        // Nested constellation
        if container.contains(.constellation) {
            let constellationContainer = try container.nestedContainer(keyedBy: ConstellationKeys.self, forKey: .constellation)
            self.constellationName = (try? constellationContainer.decode(String.self, forKey: .name)) ?? "Unknown"
        } else {
            self.constellationName = "Unknown"
        }
    }

    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(constellationId, forKey: .constellationId)
        try container.encode(postType, forKey: .postType)
        try container.encode(message, forKey: .message)

        // Date → created_at (ISO8601 without Z, to match API examples)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTime, .withDashSeparatorInDate]
        try container.encode(formatter.string(from: postTime), forKey: .createdAt)

        // Duration seconds → minutes integer
        let seconds = Int(studyDuration.components.seconds )
        try container.encode(seconds / 60, forKey: .studyDuration)

        // Nested user/constellation (only if required by your POST spec)
        var userContainer = container.nestedContainer(keyedBy: UserKeys.self, forKey: .user)
        try userContainer.encode(displayName, forKey: .displayName)

        var constellationContainer = container.nestedContainer(keyedBy: ConstellationKeys.self, forKey: .constellation)
        try constellationContainer.encode(constellationName, forKey: .name)
    }

    // Convenience initializer (used by previews / dummy data)
    init(
        id: Int = -1,
        userId: Int = -1,
        constellationId: Int = -1,
        displayName: String,
        postTime: Date,
        message: String = "",
        constellationName: String,
        postType: String,
        studyDuration: Duration = .seconds(0)
    ) {
        self.id = id
        self.userId = userId
        self.constellationId = constellationId
        self.displayName = displayName
        self.postTime = postTime
        self.message = message
        self.constellationName = constellationName
        self.postType = postType
        self.studyDuration = studyDuration
    }

    // MARK: - Date parsing helper
    /// Tries to parse strings like "2025-12-01T10:30:00" and standard ISO8601 variants.
    private static func parseDate(_ string: String) -> Date? {
        guard !string.isEmpty else { return nil }

        // Try full ISO8601 first (handles Z/timezone if present)
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = iso.date(from: string) { return d }

        // Try without fractional seconds
        iso.formatOptions = [.withInternetDateTime]
        if let d = iso.date(from: string) { return d }

        // Fallback to explicit format used by your API examples (no timezone)
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(secondsFromGMT: 0)
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return fmt.date(from: string)
    }
}


// this is temporary
var postDummyData = [
    Post(displayName: "Kaylee", postTime: Date(timeIntervalSinceReferenceDate: 384678574), message: "bluh", constellationName: "lil dipper", postType: "star", studyDuration: .seconds(61 * 60 + 31)),
    Post(displayName: "Tyler", postTime: Date(timeIntervalSinceReferenceDate: 8921), message: "hi", constellationName: "big dipper", postType: "star", studyDuration: .seconds(10 * 60)),
    Post(displayName: "Lexi", postTime: Date(timeIntervalSinceReferenceDate: 21), message: "glorbizoid", constellationName: "virgo", postType: "constellation", studyDuration: .seconds(10 * 60 + 40))
]


