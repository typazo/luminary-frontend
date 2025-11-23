//
//  SessionStartView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//
//  A view for showing the screen to start the session.
//

import Foundation
import SwiftUI

struct SessionStartView: View {
    var minutes = 5
    var seconds = 0
//    @State private var navigateToCountdown = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 30) {
                Text("Ready to start your session?")
                    .font(.title)
                
                NavigationLink(
                    destination: SetTimeView()
                ) {
                    Text("Duration: \(minutes) min : \(seconds) sec")
                        .font(.headline)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                NavigationLink(
                    destination: CountdownView(totalMinutes: minutes, totalSeconds: seconds),
//                    isActive: $navigateToCountdown //we should implement this "is active" for the constellation setting
                ) {
                    Text("Start Timer")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
