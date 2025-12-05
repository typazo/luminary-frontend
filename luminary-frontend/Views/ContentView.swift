    
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
//                            .environmentObject(UserSettings())
                        
    
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
                        let attempt = sessionManager.currentAttempt

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
                                        await MainActor.run {
                                            sessionManager.sessionFailed = true
                                        }
                                    }
                                }
                            },
                            onFinish: {
                                sessionManager.sessionActive = false
                                sessionManager.sessionFinished = true

                                Task {
                                    // 1) Complete the session
                                    guard let sessionId = sessionManager.currentSessionId else {
                                        print("No sessionId; cannot complete session.")
                                        await MainActor.run {
                                            sessionManager.sessionFailed = true
                                        }
                                        return
                                    }

                                    do {
                                        let completed = try await NetworkManager.shared.completeSession(sessionId: sessionId)
                                        print("Session \(completed.id) completed? \(completed.isCompleted), minutes: \(completed.minutes)")
                                        await MainActor.run {
                                            sessionManager.sessionFailed = false
                                        }
                                    } catch {
                                        print("Failed to complete session: \(error)")
                                        await MainActor.run {
                                            sessionManager.sessionFailed = true
                                        }
                                        return
                                    }

                                    // 2) Increment the attempt progress
                                    guard let attemptFocus = sessionManager.currentAttempt else {
                                        print("No currentAttempt; skipping incrementAttemptProgress.")
                                        return
                                    }

                                    do {
                                        let updatedAttempt = try await NetworkManager.shared.incrementAttemptProgress(attemptId: attemptFocus.id)
                                        print("Attempt \(updatedAttempt.constellationId) incremented. New progress: \(updatedAttempt.starsCompleted)")
                                    } catch {
                                        print("Failed to increment attempt: \(error)")
                                        await MainActor.run {
                                        }
                                    }
                                    
                                    var cORp = "progress"
                                    var message = "Default Study Message" //TODO: Put the user's message here
                                    var totalMins: Int? = sessionManager.totalMinutes
                                    do {
                                        let isAttemptComplete = try await
                                        NetworkManager.shared.isAttemptComplete(attemptId: attemptFocus.id)
                                        print("Successfully checked if the current attempt is complete! The value is \(isAttemptComplete).")
                                        
                                        if isAttemptComplete {
                                            cORp = "completion"
                                            message = "I just finished this Constellation!"
                                            totalMins = nil
                                            do { let completedConstellation = try await
                                                NetworkManager.shared.completeConstellationAttempt(attemptId: attemptFocus.id)
                                                print("The constellation with id \(attemptFocus.id) has been set to completed.")
                                            } catch {
                                                print("Failed to set as completed constellation with id \(attemptFocus.id)")
                                                await MainActor.run {
                                                }
                                            }
                                        }
                                    } catch {
                                        print("Failed to get isAttemptComplete attempt: \(error)")
                                        await MainActor.run {
                                        }
                                    }
                                    
                                    do {
                                        let justPostedPost = try await
                                        NetworkManager.shared.createPost(userId: settings.userId!, constellationId: attemptFocus.id, postType: cORp, message: message, studyDurationMinutes: totalMins)
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
