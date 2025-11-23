//
//  LoadingState.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation

enum LoadingState {
    case loaded
    case loading
    case error(_: Error)
}
