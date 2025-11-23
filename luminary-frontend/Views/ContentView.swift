//
//  ContentView.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import SwiftUI

struct ContentView: View {
//    @State private var currentPage: Page = .start
//
//    enum Page {
//        case start
//        case countdown
//        case feed
//    }

    var body: some View {
        //might move this tab view into a different file so we can reuse it across pages
        
        TabView {
            FeedView()
                .imageScale(.large)
                .foregroundStyle(.tint)
                .tabItem {
                    Image(systemName: "ellipses.bubble.fill") //random for now
                    Text("Feed")
                }
            SessionStartView()
                .tabItem {
                    Image(systemName: "moon.stars.fill") //random for now
                    Text("Focus")
                    //here it's a "tab item" and it just shows you what's inside the tab, but what i want it to do is route
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill") //random for now
                    Text("Profile")
                }
            DetectLeavingView()
                .tabItem {
                    Image(systemName: "person.circle.fill") //random for now
                    Text("dictatorship")
                }
        }
        .padding()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
