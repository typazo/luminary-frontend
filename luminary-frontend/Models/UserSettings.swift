//
//  UserSettings.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation
import SwiftUI
//import Combine

class UserSettings: ObservableObject {
    @Published var displayName: String? {
        didSet {
            UserDefaults.standard.set(displayName, forKey: "displayName")
        }
    }
    
    init() {
        self.displayName = UserDefaults.standard.string(forKey: "displayName")
    }
}
