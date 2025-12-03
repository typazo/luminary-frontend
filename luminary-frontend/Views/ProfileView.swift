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
    @EnvironmentObject var settings: UserSettings

    var body : some View {
        ScrollView{
            LazyVStack(spacing: 16){
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                //later ill just have one text that has different words based on if with a text variable
                if let name = settings.displayName {
                    Text("\(name)'s Galaxy :)")
                        .font(.system(size: 24))
                } else {
                    Text("Someone's Galaxy :)")
                        .font(.system(size: 24))
                }
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
                if viewModel.completedConstellations.isEmpty {
                    Text("No completed constellations yet!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.completedConstellations, id: \.self) { constellation in
                        ConstellationCell(constellation: constellation)
                            .padding(.horizontal)
                    }
                }

            }
            .padding(.vertical)
        }
        .refreshable {
            if let userId = settings.userId {
                await viewModel.fetchProfileData(for: userId)
            }
        }
        .task {
            if let userId = settings.userId {
                await viewModel.fetchProfileData(for: userId)
            }
        }

    }
}

