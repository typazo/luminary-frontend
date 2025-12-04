//
//  ConstellationListViewModel.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var completedConstellations: [Constellation] = []
    @Published var userStats: UserStats? = nil
    @Published var loadingState: LoadingState = .loading

    func fetchProfileData(for userId: Int) async {
        loadingState = .loading
        do {
            // Fetch stats + completed constellations in parallel
            async let statsTask = NetworkManager.shared.fetchUserStats(for: userId)
            async let completedTask = NetworkManager.shared.fetchCompletedConstellations(for: userId)

            let (fetchedStats, fetchedCompleted) = try await (statsTask, completedTask)

            self.userStats = fetchedStats
            self.completedConstellations = fetchedCompleted
            self.loadingState = .loaded
        } catch {
            self.loadingState = .error(error)
        }
    }
}

