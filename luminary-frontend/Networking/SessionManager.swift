//
//  SessionManager.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/23/25.
//
import SwiftUI

class SessionManager: ObservableObject {
    static let shared = SessionManager()  // singleton
    
    @Published var sessionActive: Bool = false
    @Published var sessionFailed: Bool = false
}
