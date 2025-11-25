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


    
//old version

//struct SessionActiveView : View {
//    @EnvironmentObject var sessionManager : SessionManager
//
//
//    var body: some View {
//        VStack {
//            if (sessionManager.sessionActive){
//                Text("Session")
//                CountdownView()
//
//                NavigationLink("bruh", destination: DetectLeavingView())
//                NavigationLink("cancel", destination: SessionStartView())
//                    .onTapGesture {
//                        sessionManager.sessionActive = false
//                        sessionManager.sessionFailed = true
//                    }
//            }
//        }
//    }
//}


// new version

struct SessionActiveView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.scenePhase) var scenePhase
    
    let onCancel: () -> Void
    let onFinish: () -> Void


    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Session")
                    .font(.title)

                CountdownView(
                    onCompleted: {
                        onFinish()
                    })
                .environmentObject(sessionManager)

                Button("Cancel Session") {
                    onCancel()
                }
                .foregroundColor(.red)

                Button("Finish Session") {
                    onFinish()
                }
                .foregroundColor(.blue)
                

            }
            .padding()
            .toolbar(.hidden, for: .tabBar)
            .onChange(of: scenePhase) { currentPhase in
                if (currentPhase == .background){
                    onCancel()
                }
            }
        }
    }
}
