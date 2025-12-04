//
//  PostListViewModel.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import Foundation


//enum LoadingState {
//    case loaded
//    case loading
//    case error(_: Error)
//}

@MainActor
class PostListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var loadingState: LoadingState = .loading

    private var isLoading = false

    func fetchPosts() async {
        guard !isLoading else { return }
        isLoading = true
        loadingState = .loading

        defer { isLoading = false }

        do {
            let fetchedPosts = try await NetworkManager.shared.fetchPosts()
            self.posts = fetchedPosts
            self.loadingState = .loaded
        } catch {
            self.loadingState = .error(error)
        }
    }
}

