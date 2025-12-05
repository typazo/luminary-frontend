//
//  ConstellationAttempt.swift
//  luminary-frontend
//
//  Created by Tyler on 12/4/25.
//


import Foundation

struct ConstellationAttemptFocus: Codable {
    let id: Int
    let userId: Int
    let constellationId: Int
    let starsCompleted: Int
    let user: AttemptUser
    let constellation: AttemptConstellation
    let sessions: [AttemptSession]
}

struct AttemptUser: Codable {
    let id: Int
    let displayName: String
}

struct AttemptConstellation: Codable {
    let id: Int
    let name: String
    let weight: Int
}

/// Matches the minimal session object included in the attempt's `sessions` array.
struct AttemptSession: Codable {
    let id: Int
    let userId: Int
    let constellationAttemptId: Int
    let isCompleted: Bool
    let minutes: Int
}


/// Wrapper returned by `PUT /api/constellation_attempts/{id}/complete`.
struct CompleteAttemptResponse: Codable {
    let attempt: ConstellationAttemptFocus
    let userUpdated: Bool
    let message: String
}

