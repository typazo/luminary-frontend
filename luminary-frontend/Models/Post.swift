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
}

// this is temporary
var dummyData = [
    Post(displayName: "Kalyee", postTime: Date(), message: "bluh", constelationName: "lil dipper", postType: "star"),
    Post(displayName: "Tyler", postTime: Date(), message: "hi", constelationName: "big dipper", postType: "constellation")
]
