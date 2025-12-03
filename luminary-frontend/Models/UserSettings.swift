//
//  UserSettings.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

//import Foundation
//import SwiftUI
////import Combine
//
//class UserSettings: ObservableObject {
//    @Published var displayName: String? {
//        didSet {
//            UserDefaults.standard.set(displayName, forKey: "displayName")
//        }
//    }
//
//    init() {
//        self.displayName = UserDefaults.standard.string(forKey: "displayName")
//    }
//}

import Foundation
import SwiftUI

final class UserSettings: ObservableObject {
    @Published var userId: Int? {
        didSet { UserDefaults.standard.set(userId, forKey: "userId") }
    }
    @Published var displayName: String? {
        didSet { UserDefaults.standard.set(displayName, forKey: "displayName") }
    }

    init() {
        self.userId = UserDefaults.standard.object(forKey: "userId") as? Int
        self.displayName = UserDefaults.standard.string(forKey: "displayName")
    }

    func clear() {
        userId = nil
        displayName = nil
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "displayName")
    }
}

