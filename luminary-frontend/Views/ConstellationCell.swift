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
                RoundedRectangle(cornerRadius: 15)
                // Using specific hex colors for the visual style
                    .fill(Color(red: 0.576, green: 0.447, blue: 0.600)) // Muted Mauve (e.g., #937299)
                    .overlay(
                        // Inner border style
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0.36, green: 0.27, blue: 0.38), lineWidth: 4) // Darker Border (e.g., #5C4662)
                    )
                    .frame(width: 250, height: 200) // Fixed size for the entire card
                
                
                Image("constellation_frame")
                    .resizable().scaledToFit()
                // MARK: - 2. CONTENT LAYER
                VStack(alignment: .leading, spacing: 5) {
                    
                    // Top Text (e.g., hours spent)
                    Text("7 hours spent")
                        .font(.custom("CormorantInfant-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .textCase(.lowercase)
                    
                    // Middle Text (e.g., constellation name)
                    Text("big dipper")
                        .font(.custom("CormorantInfant-SemiBold", size: 28))
                        .foregroundColor(.white)
                        .textCase(.lowercase)
                        .padding(.bottom, 10)
                    
                    // --- Constellation Graphics Placeholder ---
                    // This is where your constellation lines and stars go
                    ZStack {
                        // Placeholder for the "constellation_frame" (if it's a graphical element)

                        
                        // Placeholder for the actual constellation drawing
                        Image("constellation3_stage\(constellation.weight)") //a little confused: is weight the stage or is it the constellation #?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 155, height: 100)
                            .rotationEffect(.degrees(-90))
                    }
                    .offset(x: 30, y: 0) // Shift the constellation graphic to the right
                    
                    // Spacer to push content (like the "7 hours spent" text) to the top
                    Spacer()
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
