//
//  ConstellationCell.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import SwiftUI
//TODO: Implement the difference between a constelation and a star completion. No point in starting until I can see the design. Will implement this with an if statement that changes the view depending on the "constelation" / "star" string passed in.
struct ConstellationCell: View {
    var constellation: Constellation
//    var cellWidth: CGFloat = 128
//    let cellHeight: CGFloat = 128

    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(constellation.name)
            }
            Text("image containing \(constellation.weight) stars goes here")
                .font(.system(size: 32))
            
            
            ZStack {
                
                Rectangle()
                        .fill(Color.black)
                        .frame(width: 100, height: 55)
                
                Image("constellation_frame")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 45)

                Image("constellation1_stage1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 45)
                
            }
        }
        .background(Color.gray)
        .cornerRadius(15)
    }
}
    


struct ConstellationCell_Previews: PreviewProvider {
    static var previews: some View {
        ConstellationCell(constellation:constellationDummyData[0])
    }
}
