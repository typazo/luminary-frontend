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
                
                //TODO: Disable this constellations button when you already are working towards one
                ConstellationsDropdownView()
                
                Text("Ready to start your session?")
                    .font(.title)
                
                //the text that displays how much time you're setting the countdown for
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
                
                //the button to start the timer
                NavigationLink(
                    destination: CountdownView(totalMinutes: minutes, totalSeconds: seconds)
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

//Constellations menu -- a cute little drop down
//TODO: Figure out how to get the info from this and store it
struct ConstellationsDropdownView : View {
    @State private var selectedConstellation: Constellation = constellationDummyData[0]

    var body: some View {
        VStack {
            Menu(selectedConstellation.name) {
                ForEach(constellationDummyData, id: \.self) { constellation in
                    Button(constellation.name, action: {
                        selectedConstellation = constellation
                    })
                }
            }
            .padding(.all, 16)
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
        }

    }
}
