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

struct SessionFinishedView : View {
    let onReturnToStart: () -> Void
    
    @EnvironmentObject var sessionManager : SessionManager

    var body : some View {
        VStack(spacing: 20) {
            Text("OHH YEAH")
                .font(.title)

            Text("You earned a star!")
                .font(.headline)
            
            Text("You worked for \(sessionManager.totalMinutes) minutes and \(sessionManager.totalSeconds) seconds")
                .font(.headline)
            //right now this doesnt work because i never actually updated totals
            
            //and then an image here to show how much youve done for your constellation

            Button("Return to Start") {
                onReturnToStart() // sets sessionActive = false, returns to tabs
            }
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(8)
        }
        .padding()
        .toolbar(.hidden, for: .tabBar)
    }
}

