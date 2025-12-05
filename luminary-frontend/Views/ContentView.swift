    
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
    
    //We have to use UI kit to change the color of the tab bar
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // could also make background transparent
        appearance.backgroundColor = UIColor(red: 56/255, green: 37/255, blue: 142/255, alpha: 1.0)
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    

    var body: some View {
        Group {
            if settings.userId != nil {
                ZStack(alignment:.bottom){
                    
                    TabView(selection: $selectedTab) {
                        FeedView()
                            .tabItem {
                                Image(selectedTab == 0 ? "feed_selected" : "feed_unselected")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                Text("feed")
                                //                                .font(.custom("CormorantInfant-SemiBold", size: 21.31))
                                //                                .foregroundColor(Color.barleyWhite)
                            }
                            .tag(0)
                        
                        SessionStartView()
                            .tabItem {
                                Image(selectedTab == 1 ? "session_selected" : "session_unselected")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                Text("session")
                                //                                .font(.custom("CormorantInfant-SemiBold", size: 21.31))
                                //                                .foregroundColor(Color.barleyWhite)
                            }
                            .tag(1)
                        
                        ProfileView()
                            .tabItem {
                                Image(selectedTab == 2 ? "profile_selected" : "profile_unselected")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
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
                                        //minutesWorked: workedMinutes?
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
                                        print("Attempt \(updatedAttempt.id) incremented. New progress: \(updatedAttempt.starsCompleted)")
                                    } catch {
                                        print("Failed to increment attempt: \(error)")
                                        await MainActor.run {
                                        }
                                    }
                                    
                                    var cORp = "progress"
                                    var message = sessionManager.startMessage.isEmpty ? "Default Study Message" : sessionManager.startMessage
                                    var totalMins: Int? = sessionManager.totalMinutes
                                    do {
                                        let isAttemptComplete = try await
                                        NetworkManager.shared.isAttemptComplete(attemptId: attemptFocus.id)
                                        print("Successfully checked if the current attempt is complete! The value is \(isAttemptComplete). The current name of the constellation user is working on is \(attemptFocus.constellation.name), and the ConstellationAttemptId is \(attemptFocus.id)")
                                        
                                        if isAttemptComplete {
                                            cORp = "completion"
                                            message = "I just finished this Constellation!"
                                            totalMins = nil
                                            do { let completedConstellation = try await
                                                NetworkManager.shared.completeConstellationAttempt(attemptId: attemptFocus.id)
                                                print("The constellation: \(completedConstellation) has been set to completed. It's ID should be the same as this one \(attemptFocus.id)")
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
                                        NetworkManager.shared.createPost(userId: settings.userId!, constellationId: attemptFocus.constellation.id, postType: cORp, message: message, studyDurationMinutes: totalMins)
                                        print("The post has been posted. The post id is \(justPostedPost.id)")
                                    } catch {
                                        print("Failed to get post the post idk why")
                                        await MainActor.run {
                                        }
                                    }
                                }
                            }
                        )
                        .environmentObject(sessionManager)
                        .toolbar(.hidden, for: .tabBar)
                        .colorScheme(.dark)
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
