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

//TODO: make time and message actually adapt

struct SessionFinishedView : View {
    let onReturnToStart: () -> Void
    
    @EnvironmentObject var sessionManager : SessionManager
    
    var body : some View {
        ZStack(){
            Image("star_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea() // covers entire screen
            
            
            VStack(spacing: 20) {
                    Image("session_complete_text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 120)
                    
                    Spacer()
                    
                // -- THE BIG GLOB OF VISUAL ELEMENTS TOGETHER IN THE CENTER --
                    ZStack{
                        Image("time_completed1")
                            .offset(y: -183)
                        
                        Text("01:25")
                            .font(.custom("CormorantInfant-SemiBold", size: 45.5))
                            .foregroundStyle(Color.purpleMonster)
                            .offset(y: -175)
                        
                        Image("constellation_frame")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 290, height: 211)
                            .offset(y: -40)
                        
                        //                Image("constellation\(constellation.constellationId)_stage\(constellation.weight)") //have to connect the current one we[re on
                        Image("constellation3_stage5")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 155, height: 227)
                            .rotationEffect(.degrees(-90))
                            .offset(y: -40)
                        

                    
                        Rectangle()
                            .fill(Color.veryLightPurple)
                            .frame(width:261, height: 62)
                            .cornerRadius(5)
                            .offset(y: 96)
                        
                        Text("user's message")
                            .font(.custom("CormorantInfant-SemiBold", size: 18))
                            .foregroundStyle(Color.warmPurple)
                            .offset(y: 96)
                    }
                
                    // -- THE BIG GLOB OF VISUAL ELEMENTS TOGETHER IN THE CENTER --
                    
                    
                    Button(action: {
                        onReturnToStart()
                    }) {
                        Image("feed_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 60)
                    }
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                    
                   Spacer()
                
                
                
                
            }
            .padding()
            .toolbar(.hidden, for: .tabBar)
        }
    }
}


struct SessionFinishedViewPreviews: PreviewProvider {
    static var previews: some View {
        SessionFinishedView(onReturnToStart: {print("Return to start tapped (placeholder)")})
            .environmentObject(UserSettings())
            .environmentObject(SessionManager())
    }
}
