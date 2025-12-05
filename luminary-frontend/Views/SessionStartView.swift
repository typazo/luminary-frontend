//
//  SessionStartView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//
//  A view for showing the screen to start the session.
//

//import Foundation
//import SwiftUI
//
//struct SessionStartView: View {
//    @EnvironmentObject var sessionManager : SessionManager
//    @EnvironmentObject var settings: UserSettings
//
//    @State private var navigateToCountdown = false
////    @State private var navigateToCountdown = false
//
//
//    @State private var attempt: ConstellationAttemptFocus?
//    @State private var errorMessage: String?
//
//
//    var body: some View {
//        NavigationStack{
//            VStack(spacing: 30) {
//
//                //TODO: Disable this constellations button when you already are working towards one
//                ConstellationsDropdownView()
//
//                Text("Ready to start your session?")
//                    .font(.title)
//
//                //the text that displays how much time you're setting the countdown for
//                NavigationLink(
//                    destination: SetTimeView()
//                ) {
//                    Text("Duration: \(sessionManager.remainingMinutes) min : \(sessionManager.remainingSeconds) sec")
//                        .font(.headline)
//                    .padding()
//                    .background(Color.gray)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//
////                //the button to start the timer
////                NavigationLink(
////                    destination: CountdownView(totalMinutes: minutes, totalSeconds: seconds)
////                        .environmentObject(sessionManager) // pass the session manager
////                ) {
////                    Text("Start Timer")
////                        .padding()
////                        .background(Color.blue)
////                        .foregroundColor(.white)
////                        .cornerRadius(10)
////                }
////                .onTapGesture {
////                    sessionManager.sessionActive = true
////                }
//
//
//
//
//                Button {
//                    sessionManager.sessionActive = true
//                    sessionManager.sessionFailed = false
//                    sessionManager.sessionFinished = false
//
//                    Task {
//                        guard let userId = settings.userId else {
//                            await MainActor.run { errorMessage = "No user ID is set." }
//                            return
//                        }
//
//                        do {
//                            let result = try await NetworkManager.shared.getUserCurrentAttempt(userId: userId)
//                            await MainActor.run {
//                                attempt = result
//                                errorMessage = nil
//                            }
//                        } catch {
//                            await MainActor.run {
//                                errorMessage = "Unable to load current attempt."
//                            }
//                            print("Fetch error:", error)
//                        }
//                    }
//                } label: {
//                    Text("Start Timer")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//
//            }
//            .padding()
//        }
//    }
//
//
//}
//
////Constellations menu -- a cute little drop down
////TODO: Figure out how to get the info from this and store it
//struct ConstellationsDropdownView : View {
//    @State private var selectedConstellation: Constellation = constellationDummyData[0]
//
//    var body: some View {
//        VStack {
//            Menu(selectedConstellation.name) {
//                ForEach(constellationDummyData, id: \.self) { constellation in
//                    Button(constellation.name, action: {
//                        selectedConstellation = constellation
//                    })
//                }
//            }
//            .padding(.all, 16)
//            .foregroundStyle(Color.white)
//            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
//        }
//
//    }
//}


import SwiftUI
import Alamofire

struct SessionStartView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var settings: UserSettings

    @State private var navigateToCountdown = false

    // Your renamed attempt model
    @State private var attempt: ConstellationAttemptFocus?
    @State private var errorMessage: String?

    // Lift constellation selection up so we can use its ID to create an attempt
    @State private var selectedConstellation: Constellation = Constellation(name: "Loading…", constellationId: -1, weight: 0)

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Selection menu (binding to selectedConstellation)
                ConstellationsDropdownView(selectedConstellation: $selectedConstellation)

                Text("Ready to start your session?")
                    .font(.title)

                // Set duration
                NavigationLink(destination: SetTimeView()) {
                    Text("Duration: \(sessionManager.remainingMinutes) min : \(sessionManager.remainingSeconds) sec")
                        .font(.headline)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Start Button
                Button {
                    Task {
                        // Avoid force-unwrapping userId
                        guard let userId = settings.userId else {
                            await MainActor.run { errorMessage = "No user ID is set." }
                            return
                        }

                        do {
                            // 1) Try to fetch current attempt
                            let current = try await NetworkManager.shared.getUserCurrentAttempt(userId: userId)
                            await MainActor.run {
                                self.attempt = current
                                self.errorMessage = nil
                                // Activate session once we have an attempt
                                sessionManager.sessionActive = true
                                sessionManager.sessionFailed = false
                                sessionManager.sessionFinished = false
                            }
                        } catch {
                            // 2) If 404 (No current attempt), create one for selected constellation
                            if let afError = error as? AFError, afError.responseCode == 404 {
                                do {
                                    let created = try await NetworkManager.shared.createConstellationAttempt(
                                        userId: userId,
                                        constellationId: selectedConstellation.constellationId
                                    )
                                    await MainActor.run {
                                        self.attempt = created
                                        self.errorMessage = nil
                                        sessionManager.sessionActive = true
                                        sessionManager.sessionFailed = false
                                        sessionManager.sessionFinished = false
                                    }
                                } catch {
                                    await MainActor.run {
                                        self.errorMessage = "Failed to create a new attempt."
                                        sessionManager.sessionActive = false
                                        sessionManager.sessionFailed = true
                                    }
                                    print("Create attempt error:", error)
                                }
                            } else {
                                // 3) Other errors while fetching current attempt
                                await MainActor.run {
                                    self.errorMessage = "Unable to load current attempt."
                                    sessionManager.sessionActive = false
                                    sessionManager.sessionFailed = true
                                }
                                print("Fetch error:", error)
                            }
                        }
                    }
                } label: {
                    Text("Start Timer")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if let errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
            }
            .padding()
        }
    }
}

