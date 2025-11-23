//
//  ContentView.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = PostListViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.posts, id: \.self) { post in
                    PostCell(post: post)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            viewModel.fetchPosts()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
