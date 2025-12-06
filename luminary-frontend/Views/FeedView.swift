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
        ZStack{
            Image("star_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea() // covers entire screen
            
            ScrollView {
                Image("journey_bar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
                
                VStack(spacing: 47) {
                    
                    
                    ForEach(viewModel.posts, id: \.self) { post in
                        PostCell(post: post)
                    }
                }
                .padding(.top, 30) // This 30 points is added *after*
            }
            .refreshable {
                await viewModel.fetchPosts()
            }
            .task {
                await viewModel.fetchPosts()
            }
            .ignoresSafeArea(edges: .top)
            
        }
    }
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
