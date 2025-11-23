//
//  ConstellationListViewModel.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation


class ConstellationListViewModel: ObservableObject {

    @Published var constellations: [Constellation] = []
    @Published var loadingState: LoadingState = .loading

    
    // MARK: - Networking

//    func fetchPosts() {
//        self.loadingState = .loading
//        self.posts = []
//
//        NetworkManager.shared.fetchPosts { [weak self] fetchResult in
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//                switch fetchResult {
//                case .success(let fetchedPosts):
//                    self.posts = fetchedPosts
//                    self.loadingState = .loaded
//                case .failure(let err):
//                    self.posts = dummyData
//                    self.loadingState = .error(err)
//                }
//            }
//        }
//    }
    
    
    func fetchConstellations() async {
        self.loadingState = .loading
        
        do {
            // Call your NetworkManager async method
            let fetchedConstellations = try await NetworkManager.shared.fetchConstellations()
            
            self.constellations = fetchedConstellations
            self.loadingState = .loaded
        } catch {
            // fallback data if network fails
            self.constellations = constellationDummyData
            self.loadingState = .error(error)
        }
    }
}
