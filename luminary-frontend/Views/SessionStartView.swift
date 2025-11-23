//
//  SessionStartView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//
//  A view for showing the screen to start the session.
//

import Foundation

enum LoadingState {
    case loaded
    case loading
    case error(_: Error)
}
