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
            //            Text("image containing \(constellation.weight) stars goes here")
            //                .font(.system(size: 32))
            
            
            .background(Color.gray)
            .cornerRadius(15)
            
            ZStack {
                // MARK: - 1. BACKGROUND SHAPE
                Rectangle()
                    .fill(Color.purple)
                
                
                Image("constellation_frame")
                    .resizable().scaledToFit()
                // MARK: - 2. CONTENT LAYER
                VStack(alignment: .leading, spacing: 5) {
                    
                    // Top Text (e.g., hours spent)
                    HStack(){
                        Text("7")
                            .font(.custom("CormorantInfant-SemiBold", size: 16))
                            .foregroundColor(.veryLightPurple)
                            .textCase(.lowercase)
                        Text("hours spent")
                            .font(.custom("CormorantInfant-SemiBold", size: 16))
                            .foregroundColor(.warmPurple)
                            .textCase(.lowercase)
                            .padding(.leading, -3)
                    }
                    .padding(.bottom, -5)
                    
                    // Middle Text (e.g., constellation name)
                    Text("\(constellation.name)")
                        .font(.custom("CormorantInfant-SemiBold", size: 28))
                        .foregroundColor(.veryLightPurple)
                        .textCase(.lowercase)
                        .padding(.bottom, 10)
                    
                    // --- Constellation Graphics Placeholder ---
                    // This is where your constellation lines and stars go
                
                        // Placeholder for the actual constellation drawing
                    Image("constellation\(constellation.constellationId+1)_stage\(constellation.weight)") //a little confused: is weight the stage or is it the constellation #?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 155, height: 227)
                        .rotationEffect(.degrees(-90))

                    
                    // Spacer to push content (like the "7 hours spent" text) to the top
//                    Spacer()
                }
                // Constraint for the content area to align text to the top-left
                .frame(width: 200, height: 180, alignment: .topLeading)
            }
        }
    }
}

    


struct ConstellationCell_Previews: PreviewProvider {
    static var previews: some View {
        ConstellationCell(constellation:constellationDummyData[0])
    }
}
