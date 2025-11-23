//
//  SessionActiveView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//
//  A view for showing the current session.
//

import Foundation
import SwiftUI

struct CountdownView : View {
    @State private var remainingMinutes: Int
    @State private var remainingSeconds: Int
    @State private var timer: Timer? = nil
    @EnvironmentObject var sessionManager : SessionManager
    
    init(totalMinutes: Int, totalSeconds: Int = 0){
        remainingMinutes = totalMinutes
        remainingSeconds = totalSeconds
    }
    
    var body : some View {
        VStack{
            if (sessionManager.sessionActive){
                VStack{
                    Text("\(remainingMinutes) minutes")
                        .font(.system(size: 25, weight: .bold))
                    Text("\(remainingSeconds) seconds")
                        .font(.system(size: 25, weight: .bold))
                }
                .frame(width: 200, height: 200)
                .onAppear {
                    startTimer()
                }
                NavigationLink("bruh", destination: DetectLeavingView())
                NavigationLink("cancel", destination: SessionStartView())
                    .onTapGesture {
                        sessionManager.sessionActive = false
                        sessionManager.sessionFailed = true
                    }
            } else {
                Text("No active session")
            }
        }
    }
    
    private func startTimer() {
            // prevent multiple timers
            guard timer == nil else { return }

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else if remainingMinutes > 0 {
                    remainingMinutes -= 1
                    remainingSeconds = 59
                } else {
                    print("timer finished")
                    timer?.invalidate()
                    timer = nil
                    //here, we should route to session finished view... right now we dont do that tho
                    //perhaps we call a different function that lets us go there bc idk how we would do that here
                    //ISSUE!! it repeatedly prints timer finished even after i leave
                    sessionManager.sessionActive = false
                }
            }
        }
}
