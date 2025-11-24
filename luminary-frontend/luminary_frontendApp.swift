//
//  luminary_frontendApp.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import SwiftUI
import FamilyControls

@main
struct luminary_frontendApp: App {
    @StateObject var settings = UserSettings()  // single instance for app
    let center = AuthorizationCenter.shared //necessary for asking permission for auth
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings) 
                .task {
                    do {
                        try await center.requestAuthorization(for: .individual)
                    } catch {
                        print("Failed to get authorization: \(error)")
                    }
                }
        }
    }
}
