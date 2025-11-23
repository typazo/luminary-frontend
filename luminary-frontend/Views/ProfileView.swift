//
//  ProfileView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//

import Foundation
import SwiftUI

struct ProfileView : View {

    var body : some View {
        ScrollView{
            LazyVStack{
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Your galaxy :)")
                    .font(.system(size: 24))
                ForEach(1...100, id: \.self) {
                    Text("Row \($0)")
                }
            }
        }
    }
}

