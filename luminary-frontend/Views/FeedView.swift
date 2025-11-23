//
//  FeedView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//

import Foundation
import SwiftUI

struct FeedView : View {
    @StateObject var viewModel = PostListViewModel()
    
    var body : some View {
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
