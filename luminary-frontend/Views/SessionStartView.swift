//
//  SessionStartView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//
//  A view for showing the screen to start the session.
//


import SwiftUI
import Alamofire

@MainActor
struct SessionStartView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var settings: UserSettings

    @State private var navigateToCountdown = false
    @State private var errorMessage: String?
    @State private var selectedConstellation: Constellation = Constellation(name: "Loading…", constellationId: -1, weight: 0)
    
    @State private var activeAttempt = false
    


    var body: some View {
        NavigationStack {
            ZStack(){
                Image("new_sesh_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .padding(.top, 30)
                
                VStack(spacing: 30) {
                    // -- Dropdown of Constellation Choices --
                    if !activeAttempt {
                        Text("select a constellation to work towards")
                            .font(.custom("CormorantInfant-SemiBold", size: 12))
                            .foregroundColor(.veryLightPurple)
                            .padding(.top, 150)
                            .padding(.bottom, -25)
                        ConstellationsDropdownView(selectedConstellation: $selectedConstellation)
//                            .padding(.top, 150)
                            .padding(.bottom, 10)
                    } else {
                        if let attemptFocus = sessionManager.currentAttempt {
                            Text("selected: \(attemptFocus.constellation.name)")
                                .font(.custom("CormorantInfant-SemiBold", size: 16))
                                .foregroundColor(.amour)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.mediumOrchid)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.amour, lineWidth: 2.8)
                                )
                                .padding(.top, 150)
                                .padding(.bottom, 10)
                        } else {
                            // Provide a fallback view when currentAttempt is nil
                            Text("no current constellation attempt")
                                .font(.custom("CormorantInfant-SemiBold", size: 16))
                                .foregroundColor(.warmPurple)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.amour)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.mediumOrchid, lineWidth: 2.8) // <-- This adds the border
                                )
                                .padding(.top, 150)
                                .padding(.bottom, 10)
                        }
                    }
                    // -- Timer graphic + selected time
                    NavigationLink(destination: SetTimeView()) {
                        ZStack(){
                            Image("timer")
                                .resizable()
                                .scaledToFit()
                                .frame(height:270)
                            
                            Text(String(format: "%02d:%02d",
                                        max(0, sessionManager.remainingHours),
                                        max(0, sessionManager.remainingMinutes)))
                                .foregroundColor(Color.warmPurple)
                                .font(.custom("CormorantInfant-Bold", size: 60))
                        }
                    }
                    
                    // -- Text field for message --
                    TextField("write your message", text: $sessionManager.startMessage)
                        .padding(12)
                        .frame(height: 100)
                        .background(Color.veryLightPurple)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .font(.custom("CormorantInfant-SemiBold", size: 16))
                        .foregroundColor(Color.warmPurple)
                    

                    // -- Start Button --
                    Button {
                        Task {
                            // 0) Validate userId
                            guard let userId = settings.userId else {
                                await MainActor.run { errorMessage = "No user ID is set." }
                                return
                            }
                            
                            // 1) Resolve attempt (fetch current or create new for selected constellation)
                            var resolvedAttempt: ConstellationAttemptFocus
                            do {
                                resolvedAttempt = try await NetworkManager.shared.getUserCurrentAttempt(userId: userId)
                                await MainActor.run {
                                    sessionManager.currentAttempt = resolvedAttempt
                                    self.errorMessage = nil
                                }
                            } catch {
                                if let afError = error as? AFError, afError.responseCode == 404 {
                                    // No current attempt → create one for selected constellation
                                    do {
                                        let created = try await NetworkManager.shared.createConstellationAttempt(
                                            userId: userId,
                                            constellationId: selectedConstellation.constellationId
                                        )
                                        resolvedAttempt = created
                                        await MainActor.run {
                                            sessionManager.currentAttempt = created
                                            self.errorMessage = nil
                                        }
                                    } catch {
                                        await MainActor.run {
                                            self.errorMessage = "Failed to create a new attempt."
                                            sessionManager.sessionActive = false
                                            sessionManager.sessionFailed = true
                                            sessionManager.sessionFinished = false
                                        }
                                        print("Create attempt error:", error)
                                        return
                                        
                                        
                                    }
                                } else {
                                    await MainActor.run {
                                        self.errorMessage = "Unable to load current attempt."
                                        sessionManager.sessionActive = false
                                        sessionManager.sessionFailed = true
                                        sessionManager.sessionFinished = false
                                    }
                                    print("Fetch attempt error:", error)
                                    return
                                }
                            }

                            // 2) Compute minutes for backend (integer)
                            // Choose your rounding rule; here we round up if there are leftover seconds.
//                            let minutes = max(1, sessionManager.remainingMinutes + (sessionManager.remainingSeconds > 0 ? 1 : 0))
                            let workedMinutes = max(sessionManager.totalSessionMinutes, 0)
                            
                            print("DEBUG — Hours selected: remaining=\(sessionManager.remainingHours), total=\(sessionManager.totalHours)")
                            // 3) Create the session via NetworkManager
                            do {
                                let session = try await NetworkManager.shared.createSession(
                                    userId: userId,
                                    attemptId: resolvedAttempt.id,          // Ensure your model has `id`
                                    minutes: workedMinutes
                                )

                                // 4) Store the session id and activate UI
                                await MainActor.run {
                                    sessionManager.currentSessionId = session.id
                                    sessionManager.sessionActive = true
                                    sessionManager.sessionFailed = false
                                    sessionManager.sessionFinished = false
                                    self.errorMessage = nil
                                }

                                print("Session \(session.id) created for attempt \(resolvedAttempt.id) with \(workedMinutes) minutes.")

                            } catch {
                                await MainActor.run {
                                    self.errorMessage = "Failed to create session."
                                    sessionManager.sessionActive = false
                                    sessionManager.sessionFailed = true
                                    sessionManager.sessionFinished = false
                                }
                                print("Create session error:", error)
                            }
                        }
                    } label: {
                        Image("start_button1")
                            .resizable()
                            .scaledToFit()
                            .frame(width:184, height: 51)
                    }
                    .padding(.bottom, 175)
                    

                    if let errorMessage {
                        Text(errorMessage).foregroundColor(.red)
                    }
                }
                .padding()
                
            }
        }
        
        // ✅ This replaces your top-level Task: runs once when the view appears
        .task {
            await resolveCurrentAttemptOnAppear()
        }

    }
    
    private func resolveCurrentAttemptOnAppear() async {
        guard let userId = settings.userId else {
            errorMessage = "No user ID is set."
            return
        }

        do {
            let resolvedAttempt = try await NetworkManager.shared.getUserCurrentAttempt(userId: userId)
            // If SessionManager is @MainActor, these assignments are safe
            sessionManager.currentAttempt = resolvedAttempt
            errorMessage = nil
            activeAttempt = true
        } catch {
            if let afError = error as? AFError, afError.responseCode == 404 {
                // No current attempt exists
                activeAttempt = false
            } else {
                errorMessage = "Unable to load current attempt."
                sessionManager.sessionActive = false
                sessionManager.sessionFailed = true
                sessionManager.sessionFinished = false
                print("Fetch attempt error:", error)
            }
        }
    }
}

struct SessionStartViewPreviews: PreviewProvider {
    static var previews: some View {
        SessionStartView()
//            .environmentObject(UserSettings())
            .environmentObject(SessionManager())
    }
}
