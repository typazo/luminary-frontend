//
//  DetectLeavingView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/23/25.
//
import SwiftUI

struct DetectLeavingView : View {
    @State private var text = "hi!!"
    @Environment(\.scenePhase) var scenePhase
    //from testing, i'm noticing that app is:
    // active: when i'm actively online it
    // inactive: when i pull down notifications or pull up to the list of apps in the background
    // in the background: when i fully leave the app AND my phone is off
    
    var body : some View {
        Text(text)
            .font(.system(size: 30))
            .bold()
            .onChange(of: scenePhase){ currentPhase in
                if (currentPhase == .active) {
                    self.text = "app is active (to show we can modify stuff in app)"
                    print("app is active :)")
                } else if (currentPhase == .inactive) {
                    self.text = "app is inactive (to show we can modify stuff in app)"
                    print("app is inactive...")
                } else if (currentPhase == .background) {
                    self.text = "app is in bakground (to show we can modify stuff in app)"
                    print("act is in the background")
                }
            // onChange returns what scene we're currently in: so if we're in the app or outside -- either .active .inactive or .background
                
                
            }
    }
}
