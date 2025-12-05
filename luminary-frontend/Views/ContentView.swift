    
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
    @State private var selectedTab: Int = 0

    var body: some View {
        Group {
            if settings.userId != nil {
                ZStack(alignment:.bottom){
                    Color.blue
                            .edgesIgnoringSafeArea(.all)
                    
                    TabView(selection: $selectedTab) {
                        FeedView()
                            .tabItem {
                                Image(selectedTab == 0 ? "feed_selected" : "feed_unselected")
                                Text("feed")
                                //                                .font(.custom("CormorantInfant-SemiBold", size: 21.31))
                                //                                .foregroundColor(Color.barleyWhite)
                            }
                            .tag(0)
                        
                        SessionStartView()
                            .tabItem {
                                Image(selectedTab == 1 ? "session_selected" : "session_unselected")
                                Text("session")
                                //                                .font(.custom("CormorantInfant-SemiBold", size: 21.31))
                                //                                .foregroundColor(Color.barleyWhite)
                            }
                            .tag(1)
                        
                        ProfileView()
                            .tabItem {
                                Image(selectedTab == 2 ? "profile_selected" : "profile_unselected")
                                Text("profile")
                                //                                .font(.custom("CormorantInfant-SemiBold", size: 21.31))
                                //                                .foregroundColor(Color.barleyWhite)
                            }
                            .tag(2)
                            .environmentObject(UserSettings())
                        
    
                        #if DEBUG
                        Button("Reset Display Name") {
                            Task {
                                if let userId = settings.userId {
                                    do {
                                        try await NetworkManager.shared.deleteUser(byID: userId)
                                        print("Deleted user from backend")
                                    } catch {
                                        print("Failed to delete user: \(error)")
                                    }
                                }
                                settings.clear() // Clears userId and displayName locally
                                print("Reset displayName and userId (DEBUG)")
                            }
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
                                sessionManager.sessionActive = false
                                sessionManager.sessionFailed = true
                                Task {
                                    guard let sessionId = sessionManager.currentSessionId else {
                                        print("No sessionId; cannot cancel session.")
                                        return
                                    }
                                    do {
                                        let canceled = try await NetworkManager.shared.cancelSession(sessionId: sessionId)
                                        print("Session \(canceled.id) canceled. isCompleted: \(canceled.isCompleted), minutes: \(canceled.minutes)")
                                    } catch {
                                        print("Failed to cancel session: \(error)")
                                        // Optionally set a user-facing error state
                                        await MainActor.run {
                                            sessionManager.sessionFailed = true
                                        }
                                    }
                                }
                            },
                            onFinish: {
                                sessionManager.sessionActive = false
                                sessionManager.sessionFinished = true
                                
                                // Async network call to complete the session
                                Task {
                                    
                                    
                                    
                                    
                                    
                                    guard let sessionId = sessionManager.currentSessionId else {
                                        print("No sessionId; cannot complete session.")
                                        return
                                    }
                                    do {
                                        let completed = try await NetworkManager.shared.completeSession(sessionId: sessionId)
                                        print("Session \(completed.id) completed? \(completed.isCompleted), minutes: \(completed.minutes)")
                                        
                                        // If you track anything else after finishing (e.g., refresh attempt state/UI),
                                        // do that here, and ensure UI mutations happen on the main actor.
                                        await MainActor.run {
                                            // e.g., sessionManager.refreshAttempt() or set a success banner
                                            sessionManager.sessionFailed = false
                                        }
                                    } catch {
                                        print("Failed to complete session: \(error)")
                                        await MainActor.run {
                                            // Roll back or show an error state, if desired
                                            sessionManager.sessionFailed = true
                                            // Optionally: sessionManager.sessionFinished = false
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                            }
                        )
                        .environmentObject(sessionManager)
                        .toolbar(.hidden, for: .tabBar)
                    }
                    .fullScreenCover(isPresented: $sessionManager.sessionFinished) {
                        SessionFinishedView(onReturnToStart: {
                            sessionManager.sessionFinished = false
                            sessionManager.sessionFailed = false
                            sessionManager.sessionActive = false
                        })
                        .environmentObject(sessionManager)
                        .toolbar(.hidden, for: .tabBar)
                    }
                    .fullScreenCover(isPresented: $sessionManager.sessionFailed) {
                        SessionFailedView(onReturnToStart: {
                            sessionManager.sessionFinished = false
                            sessionManager.sessionFailed = false
                            sessionManager.sessionActive = false
                        })
                        .environmentObject(sessionManager)
                        .toolbar(.hidden, for: .tabBar)
                    }
                    .background(Color.clear)
                    
                    
                }
                
            } else {
                DisplayNameView()
            }
        }
            .onChange(of: settings.displayName) { newValue in
                print("ContentView: re-evaluated. displayName = \(String(describing: newValue))")
                
            }
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}
