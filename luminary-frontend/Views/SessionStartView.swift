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

struct SessionStartView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var settings: UserSettings

    @State private var navigateToCountdown = false
    @State private var errorMessage: String?
    @State private var selectedConstellation: Constellation = Constellation(name: "Loading…", constellationId: -1, weight: 0)
    
    @State private var message: String = ""


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
                    ConstellationsDropdownView(selectedConstellation: $selectedConstellation)
                        .padding(.top, 150)
                        .padding(.bottom, 10)
                    
                    
                    // -- Timer graphic + selected time
                    NavigationLink(destination: SetTimeView()) {
                        ZStack(){
                            Image("timer")
                                .resizable()
                                .scaledToFit()
                                .frame(height:270)
                            
                            Text("0\(sessionManager.remainingHours):\(sessionManager.remainingMinutes)")
                                .foregroundColor(Color.warmPurple)
                                .font(.custom("CormorantInfant-Bold", size: 60))
                        }
                    }
                    
                    // -- Text field for message --
                    TextField("write your message", text: $message)
                        .padding()
                        .frame(height: 100)
                        .background(Color.veryLightPurple) // light gray background
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .font(.custom("CormorantInfant-SemiBold", size: 16))
                        .foregroundStyle(Color.warmPurple)
                        .padding(.top, 10)
                    
                    Spacer()

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
                            let minutes = max(1, sessionManager.remainingMinutes + (sessionManager.remainingSeconds > 0 ? 1 : 0))

                            // 3) Create the session via NetworkManager
                            do {
                                let session = try await NetworkManager.shared.createSession(
                                    userId: userId,
                                    attemptId: resolvedAttempt.id,          // Ensure your model has `id`
                                    minutes: minutes
                                )

                                // 4) Store the session id and activate UI
                                await MainActor.run {
                                    sessionManager.currentSessionId = session.id
                                    sessionManager.sessionActive = true
                                    sessionManager.sessionFailed = false
                                    sessionManager.sessionFinished = false
                                    self.errorMessage = nil
                                }

                                print("Session \(session.id) created for attempt \(resolvedAttempt.id) with \(minutes) minutes.")

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
                    .padding(.bottom, 150)
                    

                    if let errorMessage {
                        Text(errorMessage).foregroundColor(.red)
                    }
                }
                .padding()
                
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
