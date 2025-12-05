//
//  Session.swift
//  luminary-frontend
//
//  Created by Tyler on 12/4/25.
//

import Foundation

/// Represents a study/play session tied to a constellation attempt.
struct Session: Codable {
    let id: Int
    let userId: Int
    let constellationAttemptId: Int
    let isCompleted: Bool
    let minutes: Int
    let user: SessionUser
    let constellationAttempt: SessionConstellationAttempt
}

struct SessionUser: Codable {
    let id: Int
    let displayName: String
}

/// Minimal nested attempt payload inside a Session response.
/// This is not the full ConstellationAttempt from your other file—just what the session returns.
struct SessionConstellationAttempt: Codable {
    let id: Int
    let userId: Int
    let constellationId: Int
    let starsCompleted: Int
}

