//
//  SessionFinishedView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//
// A view for showing the finished session.
//

import Foundation
import SwiftUI
import Alamofire

struct SessionFinishedView : View {
    let onReturnToStart: () -> Void
    let initialSessionActive: Bool
    
    @EnvironmentObject var sessionManager : SessionManager
    @EnvironmentObject var settings: UserSettings
    
//    @State private var errorMessage: String?
//    @State private var activeAttempt = true
    
    var bg: String {
        initialSessionActive ? "star_bg" : "alt_bg"
    }
    
    var sessionComplete: String {
        initialSessionActive ? "session_complete_text" : "constellation_completion_text"
    }
    
    var timeCompleted: String {
        initialSessionActive ? "time_completed1" : "time_completed2"
    }
    
    var timeColor: Color {
        initialSessionActive ? Color.warmPurple : Color.semiOpaqueMuted
    }
    
    var rectangleColor: Color {
        initialSessionActive ? Color.veryLightPurple : Color.darkPurp
    }
    
    
    var body : some View {
        ZStack(){
            Image(bg)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea() // covers entire screen
            
            
            VStack(spacing: 20) {
                    Image(sessionComplete)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 120)
                    
                    Spacer()
                    
                // -- THE BIG GLOB OF VISUAL ELEMENTS TOGETHER IN THE CENTER --
                    ZStack{
    
//                        Image("constellation_frame")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 290, height: 211)
//                            .offset(y: -40)
                        
                        //                Image("constellation\(constellation.constellationId)_stage\(constellation.weight)_frame") //have to connect the current one we[re on
                        if let attemptFocus = sessionManager.currentAttempt {
                            Image("constellation\(attemptFocus.constellationId)_stage\(attemptFocus.starsCompleted+1)_frame")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 254.7)
                                .offset(y: -40)
                        } else {
                            ZStack{
                                Image("constellation3_stage7_frame")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 350, height: 254.7)
                                    .offset(y: -40)
                                
                                Text("(image did not load: placeholder)")
                                    .font(.custom("CormorantInfant-SemiBold", size: 12))
                            }
                            
                        }
                        

                        Image(timeCompleted)
                            .offset(y: -183)
                        
                        Text(String(format: "%02d:%02d",
                                    sessionManager.totalHours,
                                    sessionManager.totalMinutes))
                            .font(.custom("CormorantInfant-SemiBold", size: 45.5))
                            .foregroundStyle(timeColor)
                            .offset(y: -175)
                            .opacity(initialSessionActive ? 1.0 : 0.70)
                            
                    
                        Rectangle()
                            .fill(rectangleColor)
                            .frame(width:261, height: 62)
                            .cornerRadius(5)
                            .offset(y: 96)
                        
                        Text(sessionManager.startMessage)
                            .font(.custom("CormorantInfant-SemiBold", size: 18))
                            .foregroundStyle(Color.warmPurple)
                            .offset(y: 96)
                    }
                
                    // -- THE BIG GLOB OF VISUAL ELEMENTS TOGETHER IN THE CENTER --
                    
                    
                    Button(action: {
                        onReturnToStart()
                    }) {
                        Image("feed_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 60)
                    }
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                    
                   Spacer()
                
                
                
                
            }
            .padding()
            .toolbar(.hidden, for: .tabBar)
        }
//        .task {
//            await resolveCurrentAttemptOnAppear()
//        }
    }
    
//    @MainActor
//    private func resolveCurrentAttemptOnAppear() async {
//        guard let userId = settings.userId else {
//            errorMessage = "No user ID is set."
//            return
//        }
//
//        do {
//            let resolvedAttempt = try await NetworkManager.shared.getUserCurrentAttempt(userId: userId)
//            errorMessage = nil
//            activeAttempt = true
//        } catch {
//            if let afError = error as? AFError, afError.responseCode == 404 {
//                // No current attempt exists
//                activeAttempt = false
//                print("This time it should show constellation stuff")
//            } else {
//                errorMessage = "Unable to load current attempt."
//                sessionManager.sessionActive = false
//                sessionManager.sessionFailed = true
//                sessionManager.sessionFinished = false
//                print("Fetch attempt error:", error)
//            }
//        }
//    }
}


struct SessionFinishedViewPreviews: PreviewProvider {
    static var previews: some View {
        SessionFinishedView(onReturnToStart: {print("Return to start tapped (placeholder)")}, initialSessionActive: true)
            .environmentObject(UserSettings())
            .environmentObject(SessionManager())
    }
}
