//
//  SessionManager.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/23/25.
//
import SwiftUI

@MainActor
class SessionManager: ObservableObject {
    static let shared = SessionManager()  // singleton
    
    @Published var sessionActive: Bool = false
    @Published var sessionFailed: Bool = false
    @Published var sessionFinished: Bool = false
    
    @Published var totalMinutes: Int = 5
    @Published var totalSeconds: Int = 0

    @Published var remainingHours: Int = 0
    @Published var remainingMinutes: Int = 5
    @Published var remainingSeconds: Int = 0
    
    @Published var currentSessionId: Int? = nil
    
    @Published var currentAttempt: ConstellationAttemptFocus? = nil
}
