//
//  SessionFailedView.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation
import SwiftUI

struct SessionFailedView: View {
    let onReturnToStart: () -> Void

    var body: some View {
        ZStack(){
            Image("star_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea() // covers entire screen
         
            VStack(spacing: 16) {
                
    //            Text("Your session failed so your star faded")
    //                .font(.title)
                Image("faded_text")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top, 120)
                    
                
                Spacer()
                
                Image("star_fade")
                    .resizable()
                    .scaledToFit()
                    .frame(width:250)
            
                Spacer()
                
                Button(action: {
                    onReturnToStart()
                }) {
                    Text("Try Again")
                        .font(.custom("CormorantInfant-SemiBold", size: 20))
                        .foregroundColor(.warmPurple)
                        .padding()
                        .frame(maxWidth: 216)
                        .background(Color.veryLightPurple)
                        .cornerRadius(8)
                        
                }
            }
            .padding(.bottom, 180)
            .padding()
            .toolbar(.hidden, for: .tabBar)
        }
        
    }
        
}


struct SessionFailedView_Previews: PreviewProvider {
    static var previews: some View {
        SessionFailedView(onReturnToStart: {print("Return to start tapped (placeholder)")})
    }
}
