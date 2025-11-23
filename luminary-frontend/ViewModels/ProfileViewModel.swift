//
//  ConstellationListViewModel.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation


class ProfileViewModel: ObservableObject {

    @Published var constellations: [Constellation] = []
    @Published var userStats: UserStats? = nil
    @Published var loadingState: LoadingState = .loading
    


    
    
//    func fetchConstellations() async {
//        self.loadingState = .loading
//
//        do {
//            // Call your NetworkManager async method
//            let fetchedConstellations = try await NetworkManager.shared.fetchConstellations()
//
//            self.constellations = fetchedConstellations
//            self.loadingState = .loaded
//        } catch {
//            // fallback data if network fails
//            self.constellations = constellationDummyData
//            self.loadingState = .error(error)
//        }
//    }
    
    // MARK: - Networking
    
    func fetchProfileData() async {
        loadingState = .loading
        
        do {
            // Fetch constellations and stats in parallel
            async let constellationsTask = NetworkManager.shared.fetchConstellations()
            async let statsTask = NetworkManager.shared.fetchUserStats()
            
            let (fetchedConstellations, fetchedStats) = try await (constellationsTask, statsTask)
            
            // Update published properties
            constellations = fetchedConstellations
            userStats = fetchedStats
            loadingState = .loaded
        } catch {
            // Fallback data on failure
            constellations = constellationDummyData
            userStats = UserStats.defaultStats
            loadingState = .error(error)
        }
    }
}
