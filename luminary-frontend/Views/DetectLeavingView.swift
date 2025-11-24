//
//  DetectLeavingView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/23/25.
//
import SwiftUI


struct DetectLeavingView : View {
    @EnvironmentObject var sessionManager : SessionManager
    @State private var text = "hi!!"
    @Environment(\.scenePhase) var scenePhase
    //from testing, i'm noticing that app is:
    // active: when i'm actively online it
    // inactive: when i pull down notifications or pull up to the list of apps in the background
    // in the background: when i fully leave the app OR my phone is off
    
    
    var body : some View {
        Text(text)
            .font(.system(size: 30))
            .bold()
            .onAppear {
                self.updateText(currentPhase: scenePhase)
            }
            .onChange(of: scenePhase){ currentPhase in
                self.updateText(currentPhase: currentPhase)
            }
    }
    
    private func updateText(currentPhase: ScenePhase) {
            if (sessionManager.sessionActive){
                if (currentPhase == .active || currentPhase == .inactive){
                    self.text = "your star is growing brighter!! session is active"
                } else if (currentPhase == .background) {
//                    self.text = "YOUR STAR FADED. HOW COULD YOU"
//                    print("app is in the background")
                    sessionManager.sessionActive = false
                    sessionManager.sessionFailed = true
                    //forcibly switch to the "sessionfinishedview"
                }
            } else {
                self.text = "u dont have a session going lol"
            }
        }
    
}
