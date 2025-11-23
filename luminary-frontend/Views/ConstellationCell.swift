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
