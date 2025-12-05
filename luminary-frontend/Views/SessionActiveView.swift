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
    
    @State private var selectedConstellation: Constellation = Constellation(name: "Loading…", constellationId: -1, weight: 0)
    
    let onCancel: () -> Void
    let onFinish: () -> Void


    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .topTrailing){
                Image("star_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea() // covers entire screen
                    
                Image("timer_alt")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 264)
                    .padding(.top, -30)        // push upward off-screen
                    .padding(.trailing, -30)
                
                //the actual timer
                CountdownView(
                        onCompleted: {
                            onFinish()
                        })
                    .environmentObject(sessionManager)
                    .padding(.top, -15)        // push upward off-screen
                    .padding(.trailing, 5)
                    
                Button(action: {
                    onCancel()
                }) {
                    Image("quit_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, 70)         // push it partially off-screen if you want
                .padding(.leading, 20)
                
                VStack(spacing: 16) {
                    
                   Spacer()
                    
                    if let attemptFocus = sessionManager.currentAttempt {
                        Image("constellation\(attemptFocus.constellationId)_stage\(attemptFocus.starsCompleted+1)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 325)
                            .offset(y: 50)
                    } else {
                        //just a debug
                        ZStack{
                            Image("constellation2_stage2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 325)
                                .offset(y: 50)
                            
                            Text("(image did not load: placeholder)")
                                .font(.custom("CormorantInfant-SemiBold", size: 12))
                                .foregroundStyle(Color.white)
                        }
                        
                    }

                    Spacer()
                    
                    
                    //DEBUG BUTTON
                    Button("Finish Session") {
                        onFinish()
                    }
                    .foregroundColor(.blue)
                    
                    ZStack(){
                        Image("active_message")
                            .resizable()
                            .scaledToFit()   // keeps natural proportions and height
                            .frame(maxWidth: .infinity, alignment: .center)
                            .clipped()
                            .padding(.bottom, -1)
                        
                        Text(sessionManager.startMessage)
                            .font(.custom("CormorantInfant-SemiBold", size: 27))
                            .foregroundColor(Color.warmPurple)
                    }
                    
                    
                   
                    
                }
                .ignoresSafeArea()
                .toolbar(.hidden, for: .tabBar)
                .onChange(of: scenePhase) { currentPhase in
                    if (currentPhase == .background){
                        onCancel()
                    }
                }
                
                
                
            }
            .ignoresSafeArea()
            
        }
        
        
        
        
    }
}

struct SessionActiveViewPreviews: PreviewProvider {
    static var previews: some View {
        SessionActiveView(onCancel:{print("meow")}, onFinish:{print("meooow")})
            .environmentObject(UserSettings())
            .environmentObject(SessionManager())
    }
}
