//
//  ConstellationListViewModel.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation



@MainActor
class ProfileViewModel: ObservableObject {
    @Published var constellations: [Constellation] = []
    @Published var completedConstellations: [Constellation] = []
    @Published var userStats: UserStats? = nil
    @Published var loadingState: LoadingState = .loading

    func fetchProfileData(for userId: Int) async {
        loadingState = .loading
        do {
            async let constellationsTask = NetworkManager.shared.fetchConstellations()
            async let statsTask = NetworkManager.shared.fetchUserStats()
            async let completedTask = NetworkManager.shared.fetchCompletedConstellations(for: userId)

            let (fetchedConstellations, fetchedStats, fetchedCompleted) = try await (constellationsTask, statsTask, completedTask)

            constellations = fetchedConstellations
            userStats = fetchedStats
            completedConstellations = fetchedCompleted
            loadingState = .loaded
        } catch {
            constellations = constellationDummyData
            userStats = UserStats.defaultStats
            completedConstellations = []
            loadingState = .error(error)
        }
    }
}
