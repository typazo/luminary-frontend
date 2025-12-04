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
