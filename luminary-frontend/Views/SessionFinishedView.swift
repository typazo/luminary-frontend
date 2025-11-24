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
//old

////We need to distinguish between a fail and a success
//struct SessionFinishedView : View {
//
//
//    var body : some View {
//        VStack{
//            Text("Wow you finished the session lfg")
//        }
//    }
//}


// new

struct SessionFinishedView : View {
    let onReturnToStart: () -> Void

    var body : some View {
        VStack(spacing: 20) {
            Text("Nice work! 🎉")
                .font(.title)

            Text("You finished the session.")
                .font(.headline)

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

