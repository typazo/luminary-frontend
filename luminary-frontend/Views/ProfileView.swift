//
//  ProfileView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//

import Foundation
import SwiftUI

struct ProfileView : View {
    @StateObject var viewModel = ProfileViewModel()

    var body : some View {
        ScrollView{
            LazyVStack(spacing: 16){
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Your galaxy :)")
                    .font(.system(size: 24))
                if let stats = viewModel.userStats {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Stars completed: \(stats.starsCompleted)")
                        Text("Constellations Completed: \(stats.constellationsCompleted)")
                        Text("Hours Studied: \(stats.hoursStudied)")
                    }
                    .font(.headline)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                ForEach(viewModel.constellations, id: \.self) { constellation in
                    ConstellationCell(constellation: constellation)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .refreshable {
            await viewModel.fetchProfileData()
        }
        .task {
            await viewModel.fetchProfileData()
        }

    }
}

