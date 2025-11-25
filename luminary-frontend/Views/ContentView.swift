    
//
//  ContentView.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import SwiftUI

struct ContentView: View {
    // If you bring back paging later:
    // @State private var currentPage: Page = .start
    // enum Page { case start, countdown, feed }

    //@StateObject var sessionManager = SessionManager.shared
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        Group {
            // Gate: show setup until displayName is set
            if settings.displayName != nil {
                TabView {
                    FeedView()
                        .tabItem {
                            Image(systemName: "ellipses.bubble.fill")
                            Text("Feed")
                        }

                    SessionStartView()
                        .tabItem {
                            Image(systemName: "moon.stars.fill")
                            Text("Focus")
                        }

                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("Profile")
                        }
                        .environmentObject(UserSettings())

//                    DetectLeavingView()
//                        .tabItem {
//                            Image(systemName: "person.circle.fill")
//                            Text("dictatorship")
//                        }

                    // Dev-only helper tab to reset the onboarding gate
                    #if DEBUG
                    // Dev-only helper tab
                    Button("Reset Display Name") {
                        UserDefaults.standard.removeObject(forKey: "displayName")
                        settings.displayName = nil
                        print("Reset displayName (DEBUG)")
                    }
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(8)
                    .tabItem {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                    #endif

                }
                
                .fullScreenCover(isPresented: $sessionManager.sessionActive) {
                    SessionActiveView(
                        onCancel: {
                            // cancel → failed screen
                            sessionManager.sessionActive = false
                            sessionManager.sessionFailed = true
                        },
                        onFinish: {
                            // finish → finished screen
                            sessionManager.sessionActive = false
                            sessionManager.sessionFinished = true
                        }
                    )
                    .environmentObject(sessionManager)
                    .toolbar(.hidden, for: .tabBar)
                }
                // ✅ Present FINISHED full-screen
                .fullScreenCover(isPresented: $sessionManager.sessionFinished) {
                    SessionFinishedView(onReturnToStart: {
                        // return → dismiss cover and reset flags
                        sessionManager.sessionFinished = false
                        sessionManager.sessionFailed = false
                        sessionManager.sessionActive = false
                    })
                    .environmentObject(sessionManager)
                    .toolbar(.hidden, for: .tabBar)
                }
                // ✅ Present FAILED full-screen (optional)
                .fullScreenCover(isPresented: $sessionManager.sessionFailed) {
                    SessionFailedView(onReturnToStart: {
                        sessionManager.sessionFinished = false
                        sessionManager.sessionFailed = false
                        sessionManager.sessionActive = false
                    })
                    .environmentObject(sessionManager)
                    .toolbar(.hidden, for: .tabBar)
                }
            } else {
                DisplayNameView()
                // No need to re-inject settings; already inherited from environment
            }
        }
        // Log changes in displayName without breaking ViewBuilder
        .onChange(of: settings.displayName) { newValue in
            print("ContentView: re-evaluated. displayName = \(String(describing: newValue))")
            
        }
        // Optional: animate the transition between onboarding and app shell
        .animation(.default, value: settings.displayName)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}
