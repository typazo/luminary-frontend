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


    


struct SessionActiveView : View {
    @EnvironmentObject var sessionManager : SessionManager
    
    
    var body: some View {
        VStack {
            if (sessionManager.sessionActive){
                Text("Session")
                CountdownView()
                
                NavigationLink("bruh", destination: DetectLeavingView())
                NavigationLink("cancel", destination: SessionStartView())
                    .onTapGesture {
                        sessionManager.sessionActive = false
                        sessionManager.sessionFailed = true
                    }
            }
        }
    }
}
