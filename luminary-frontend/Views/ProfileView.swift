//
//  ProfileView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//

import Foundation
import SwiftUI

//struct ProfileView : View {
//    @StateObject var viewModel = ProfileViewModel()
//    @EnvironmentObject var settings: UserSettings
//
//    var body : some View {
//        GeometryReader { fullGeo in
//            ZStack{
//                Image("star_bg")
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea() // covers entire screen
//
//                GeometryReader { contentGeo in
//                    ScrollView{
//                        LazyVStack(spacing: 16){
//                            Image("sample_pfp")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 117, height: 117)
//                            //                                .padding(.top,0)
//
//                            if let name = settings.displayName {
//                                Text("\(name)'s galaxy")
//                                    .font(.custom("CormorantInfant-Bold", size: 35))
//                                    .foregroundColor(Color.mediumOrchid)
//                                //                        } else {
//                                //                            Text("Someone's Galaxy :)")
//                                //                                                .font(.system(size: 24))
//                            }
//
//
//                            // MARK: -- STATS
//                            if let stats = viewModel.userStats {
//                                VStack(alignment: .leading, spacing:10){
//
//                                    HStack(spacing: 8){
//                                        // --- Col1: numbers ---
//                                        VStack(alignment: .trailing){
//                                            Text("\(stats.hoursStudied)")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
//                                                .frame(width: 30, alignment: .trailing)
//                                                .foregroundColor(Color.amour)
//                                            Text("\(stats.starsCompleted)")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
//                                                .frame(width: 30, alignment: .trailing)
//                                                .foregroundColor(Color.amour)
//                                            Text("\(stats.constellationsCompleted)")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
//                                                .frame(width: 30, alignment: .trailing)
//                                                .foregroundColor(Color.amour)
//                                        }
//
//                                        // --- Col2: dots ---
//                                        VStack(){
//                                            Text("•")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
//                                                .foregroundColor(Color.amour)
//                                            Text("•")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
//                                                .foregroundColor(Color.amour)
//                                            Text("•")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
//                                                .foregroundColor(Color.amour)
//                                        }
//
//                                        // --- Col3: text ---
//                                        VStack(alignment: .leading){
//                                            Text("hours completed")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
//                                                .foregroundColor(Color.mediumOrchid)
//                                            Text("stars completed")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
//                                                .foregroundColor(Color.mediumOrchid)
//                                            Text("constellations completed")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
//                                                .foregroundColor(Color.mediumOrchid)
//                                        }
//
//                                    }
//                                }
//                            }
//
//                            VStack(spacing: 0){
//                                Rectangle()
//                                    .fill(Color.veryLightPurple)
//                                    .frame(height: 6)
//                                    .edgesIgnoringSafeArea(.horizontal)
//
//                                ZStack{
//
//                                    let topContentHeight = contentGeo.frame(in: .local).minY
//                                    let screenHeight = fullGeo.size.height
//
//                                    // The minimum height is the full screen height minus the height of the content above.
//                                    let minConstellationHeight = screenHeight - topContentHeight
//
//                                    // Background Rectangle (Layer 1)
//                                    Rectangle()
//                                        .fill(Color.mediumOrchid)
//                                        .opacity(0.63)
//                                        .frame(maxWidth: .infinity)
//                                    // Apply the calculated minimum height
//                                        .frame(minHeight: minConstellationHeight)
//
//                                    VStack{
//                                        if viewModel.completedConstellations.isEmpty {
//                                            Text("no constellations \nachieved yet")
//                                                .font(.custom("CormorantInfant-SemiBold", size: 30))
//                                                .foregroundColor(Color.amour)
//                                                .multilineTextAlignment(.center)
//                                            //                                    Spacer()
//                                        } else {
//                                            ForEach(viewModel.completedConstellations, id: \.self) { constellation in
//                                                ConstellationCell(constellation: constellation)
//                                                    .padding(.horizontal)
//                                            }
//                                            //                                    Spacer()
//                                        }
//                                        Spacer()
//                                    }
//                                    .padding(.top, 20)
//                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                                }
//                            }
//                            .padding(.vertical)
//                            Color.clear
//                        }
//                        .refreshable {
//                            if let userId = settings.userId {
//                                await viewModel.fetchProfileData(for: userId)
//                            }
//                        }
//                        .task {
//                            if let userId = settings.userId {
//                                await viewModel.fetchProfileData(for: userId)
//                            }
//                        }
//                    }
//
//                }
//            }
//        }
//    }
//}


//maybe work better? idk

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        GeometryReader { fullGeo in
            ZStack {
                Image("star_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                GeometryReader { contentGeo in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            Image("sample_pfp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 117, height: 117)

                            if let name = settings.displayName {
                                Text("\(name)'s galaxy")
                                    .font(.custom("CormorantInfant-Bold", size: 35))
                                    .foregroundColor(Color.mediumOrchid)
                            }

                            // MARK: -- STATS
                            if let stats = viewModel.userStats {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 8) {
                                        VStack(alignment: .trailing) {
                                            Text("\(stats.hoursStudied)")
                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
                                                .frame(width: 30, alignment: .trailing)
                                                .foregroundColor(Color.amour)
                                            Text("\(stats.starsCompleted)")
                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
                                                .frame(width: 30, alignment: .trailing)
                                                .foregroundColor(Color.amour)
                                            Text("\(stats.constellationsCompleted)")
                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
                                                .frame(width: 30, alignment: .trailing)
                                                .foregroundColor(Color.amour)
                                        }

                                        VStack {
                                            Text("•")
                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
                                                .foregroundColor(Color.amour)
                                            Text("•")
                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
                                                .foregroundColor(Color.amour)
                                            Text("•")
                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
                                                .foregroundColor(Color.amour)
                                        }

                                        VStack(alignment: .leading) {
                                            Text("hours completed")
                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
                                                .foregroundColor(Color.mediumOrchid)
                                            Text("stars completed")
                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
                                                .foregroundColor(Color.mediumOrchid)
                                            Text("constellations completed")
                                                .font(.custom("CormorantInfant-SemiBold", size: 19))
                                                .foregroundColor(Color.mediumOrchid)
                                        }
                                    }
                                }
                            }

                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color.veryLightPurple)
                                    .frame(height: 6)
                                    .edgesIgnoringSafeArea(.horizontal)

                                ZStack {
                                    let topContentHeight = contentGeo.frame(in: .local).minY
                                    let screenHeight = fullGeo.size.height
                                    let minConstellationHeight = screenHeight - topContentHeight

                                    Rectangle()
                                        .fill(Color.mediumOrchid)
                                        .opacity(0.63)
                                        .frame(maxWidth: .infinity)
                                        .frame(minHeight: minConstellationHeight)

                                    VStack {
                                        if viewModel.completedConstellations.isEmpty {
                                            Text("no constellations \nachieved yet")
                                                .font(.custom("CormorantInfant-SemiBold", size: 30))
                                                .foregroundColor(Color.amour)
                                                .multilineTextAlignment(.center)
                                        } else {
                                            ForEach(viewModel.completedConstellations, id: \.self) { constellation in
                                                ConstellationCell(constellation: constellation)
                                                    .padding(.horizontal)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.top, 20)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                }
                            }
                            .padding(.vertical)

                            Color.clear
                        }
                        .refreshable {
                            if let userId = settings.userId {
                                await viewModel.fetchProfileData(for: userId)
                            }
                        }
                    }
                    // Prefer attaching .task here or to the ZStack/outer container
                    .task(id: settings.userId) {
                        if let userId = settings.userId {
                            await viewModel.fetchProfileData(for: userId)
                        }
                    }
                }
            }
        }
    }
}
