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
    
    
    
    @Published var startMessage: String = ""

    /// Optional helpers to keep things tidy between sessions:
    func resetForNewSession() { //for now this is not used
        // reset flags as needed; keep or clear message depending on your UX
        sessionActive = false
        sessionFailed = false
        sessionFinished = false
        // If you want to clear after finish/cancel, call clearMessage() there.
    }

    func clearMessage() {
        startMessage = ""
    }

}
