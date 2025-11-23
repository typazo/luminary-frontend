//
//  PostListViewModel.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import Foundation


enum LoadingState {
    case loaded
    case loading
    case error(_: Error)
}

class BirdListViewModel: ObservableObject {

    @Published var posts: [Post] = []
    @Published var loadingState: LoadingState = .loading

//    // MARK: - Functions
//
//    func loadFavorites() {
//        // 1. fetch favorited bird names from UserDefaults
//        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? []
//
//        // 2. load favorites into the birds property
//        // NOTE: We must redeclare the property for the ViewModel to be notified of changes
//        birds = birds.map {
//            var birdCopy = $0
//            if favorites.contains(birdCopy.name) {
//                birdCopy.isFavorited = true
//            }
//            return birdCopy
//        }
//    }
//
//    func toggleFavorite(_ bird: Bird) {
//        // NOTE: For more sensitive data, you can use Apple's iCloud Keychain through the Keychain API
//
//        // 1. fetch favorited bird names from UserDefaults
//        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? []
//
//        // 2. Toggling favorite
//        if favorites.contains(bird.name) {
//            // favorited already
//            favorites.removeAll { name in
//                name == bird.name
//            }
//        } else {
//            // not favorited yet
//            favorites.append(bird.name)
//        }
//
//        // 3. Update UserDefaults
//        UserDefaults.standard.setValue(favorites, forKey: "favorites")
//
//        // 4. Update birds property
//        // NOTE: We must redeclare the property for the ViewModel to be notified of changes
//        birds = birds.map {
//            if $0.name == bird.name {
//                var birdCopy = $0
//                birdCopy.isFavorited.toggle()
//                return birdCopy
//            } else {
//                return $0
//            }
//        }
//    }
    
    // MARK: - Networking

    func fetchPosts() {
        self.loadingState = .loading
        self.posts = []

        NetworkManager.shared.fetchPosts { [weak self] fetchResult in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch fetchResult {
                case .success(let fetchedPosts):
                    self.posts = fetchedPosts
                    self.loadingState = .loaded
                    self.loadFavorites()
                case .failure(let err):
                    self.loadingState = .error(err)
                }
            }
        }
    }
}
