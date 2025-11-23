//
//  UserStats.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation

struct UserStats: Hashable, Codable {
    let starsCompleted: Int
    let constellationsCompleted: Int
    let hoursStudied: Int

    static let defaultStats = UserStats(starsCompleted: 8, constellationsCompleted: 1, hoursStudied: 10)
}
