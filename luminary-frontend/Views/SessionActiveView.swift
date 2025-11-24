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
    
    let onCancel: () -> Void
    let onFinish: () -> Void


    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Session")
                    .font(.title)

                CountdownView(
                    onCompleted: {
                        // This should route to the finished screen in your cover.
                        // If you are using the SessionCoverRouter approach:
                        onFinish() // switches the router to SessionFinishedView
                    })
                .environmentObject(sessionManager)

                Button("Cancel Session") {
                    onCancel() // sets sessionFailed = true
                }
                .foregroundColor(.red)

                Button("Finish Session") {
                    onFinish() // flips to finished screen in the router
                }
                .foregroundColor(.blue)

            }
            .padding()
            .toolbar(.hidden, for: .tabBar) // keep tab bar hidden while full-screen
        }
    }
}
