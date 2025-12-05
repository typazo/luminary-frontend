//
//  ConstellationListViewModel.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    // Now holds completed **attempts** instead of Constellations
    @Published var completedConstellations: [ConstellationAttemptFocus] = []
    @Published var userStats: UserStats? = nil
    @Published var loadingState: LoadingState = .loading

    func fetchProfileData(for userId: Int) async {
        loadingState = .loading
        do {
            // Fetch stats + completed attempts in parallel
            async let statsTask = NetworkManager.shared.fetchUserStats(for: userId)
            async let completedTask = NetworkManager.shared.fetchCompletedConstellationAttempts(for: userId)

            let (fetchedStats, fetchedCompletedAttempts) = try await (statsTask, completedTask)

            self.userStats = fetchedStats
            self.completedConstellations = fetchedCompletedAttempts
            self.loadingState = .loaded
        } catch {
            self.loadingState = .error(error)
        }
    }
}

