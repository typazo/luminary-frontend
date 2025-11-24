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
        VStack(spacing: 16) {
            Text("Session cancelled")
                .font(.title)
            Button("Return to Start") {
                onReturnToStart()
            }
            .padding()
            .background(Color.red.opacity(0.2))
            .cornerRadius(8)
        }
        .padding()
        .toolbar(.hidden, for: .tabBar)
    }
}
