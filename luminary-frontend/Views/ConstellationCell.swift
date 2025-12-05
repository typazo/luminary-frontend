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
            
            ZStack {
                // MARK: - 1. BACKGROUND SHAPE
//                Rectangle()
//                    .fill(Color.purple)
                
                
                Image("constellation_frame")
                    .frame(width: 315, height: 230)
                // MARK: - 2. CONTENT LAYER
                ZStack() {
                    VStack(alignment: .leading){
                        // Top Text (e.g., hours spent)
                        HStack(){
                            Text("7")
                                .font(.custom("CormorantInfant-SemiBold", size: 20))
                                .foregroundColor(.amour)
                                .textCase(.lowercase)
                            Text("hours spent")
                                .font(.custom("CormorantInfant-SemiBold", size: 20))
                                .foregroundColor(.veryLightPurple)
                                .textCase(.lowercase)
                                .padding(.leading, -3)
                        }
                        .padding(.bottom, -25)
                        
                        // Middle Text (e.g., constellation name)
                        Text("\(constellation.name)")
                            .font(.custom("CormorantInfant-SemiBold", size: 35))
                            .foregroundColor(.amour)
                            .textCase(.lowercase)
                            .padding(.bottom, 10)
                    }
                    .frame(width: 315, height: 230, alignment: .topLeading)
                    
                    .padding(.top, 20)
                    .padding(.leading, 15)
                    
                    Image("constellation\(constellation.constellationId)_stage\(constellation.weight)") //a little confused: is weight the stage or is it the constellation #?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 155, height: 227)
                        .rotationEffect(.degrees(-90))
                }
            }
        }
    }
}

    


struct ConstellationCell_Previews: PreviewProvider {
    static var previews: some View {
        ConstellationCell(constellation:constellationDummyData[0])
    }
}
