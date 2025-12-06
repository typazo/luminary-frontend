//
//  PostCell.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import SwiftUI
//TODO: Implement the difference between a constelation and a star completion. No point in starting until I can see the design. Will implement this with an if statement that changes the view depending on the "constelation" / "star" string passed in.




struct PostCell: View {
    var post: Post
    

    var workingVsFinished: String {
        post.postType == "completion" ? "finished.." : "working on.."
    }
    
    var backgroundColor: Color {
        post.postType == "completion" ? Color.amour : Color.veryLightPurple
    }
    
    var starOrConstImg: String {
        post.postType == "completion" ? "constellation_icon" : "star_feed"
    }
    
    var starOrConstText: String {
        post.postType == "completion" ? "constellation" : "star"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            //stack for the information at the top
            // MARK: - The top section of information
            HStack(alignment: .top){
                HStack(alignment: .center, spacing: 12) {
                    
                    Image("sample_pfp")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    
                    VStack(alignment: .leading, spacing: 2){
                        Text("@"+post.displayName)
                            .font(.custom("CormorantInfant-Bold", size: 24))
                            .foregroundColor(Color.warmPurple)
                        
                        Text(post.postTime.formattedTimestamp())
                            .font(.custom("CormorantInfant-SemiBold", size: 13))
                            .foregroundColor(Color.warmPurple)
                    }
                }
                Spacer()
                
                // VStack for "working on.." and "big dipper" (Right side)
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(workingVsFinished)
                                    .font(.custom("CormorantInfant-SemiBold", size: 16)) // Slightly larger font
                                    .foregroundColor(Color.mediumOrchid)
                                    .padding(.bottom, -5)
                                
                                Text("\(post.constellationName)")
                                    .font(.custom("CormorantInfant-Bold", size: 27))
                                    .foregroundColor(Color.warmPurple)
                            }
                
            }.padding(.horizontal, 24)
                
            //the rest
            Text("“"+post.message+"”")
                .font(.custom("CormorantInfant-SemiBold", size: 12))
                .foregroundColor(Color.warmPurple)
                .offset(y: 10)
                .padding(.horizontal, 24)
                .padding(.bottom, 4)
                
            //MARK: - The box
            ZStack {
                Rectangle()
                    .fill(Color.mediumOrchid)
                    .frame(height: 120)

                Rectangle()
                    .fill(backgroundColor)
                    .padding(3.74)

                // Center inner content vertically within the box

                // ======= INNER CONTENT (place this inside your existing ZStack) =======
                VStack(spacing: 8) {

                    // TOP ROW: Timer (trailing) • Dot (narrow) • Image (leading)
                    HStack(alignment: .center, spacing: 0) {
                        // Left column: Timer, right-aligned to hug the dot
                        Text("\(post.studyDuration.formattedHHMM())")
                            .font(.custom("CormorantInfant-SemiBold", size: 50))
                            .foregroundColor(Color.mediumOrchid)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 16) // ← tiny gap to the dot

                        // Dot — very narrow
                        Text("•")
                            .font(.system(size: 22, weight: .bold)) // slightly smaller dot
                            .foregroundColor(Color.mediumOrchid)
                            .frame(width: 8, alignment: .center)     // ← as narrow as possible

                        // Right column: Image, left-aligned to hug the dot
                        Image(starOrConstImg)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 60)            // a touch shorter helps closeness
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)                    // ← tiny gap to the dot
                    }
                    .frame(maxWidth: 332)

                    // BOTTOM ROW: Captions — mirror the dot width with a transparent spacer
                    HStack(alignment: .top, spacing: 0) {
                        Text("time completed")
                            .font(.custom("CormorantInfant-SemiBold", size: 11))
                            .foregroundColor(Color.mediumOrchid)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .multilineTextAlignment(.center)
                            .padding(.trailing, post.postType == "completion" ? 32 : 32) // mirror tiny gap above

                        Color.clear
                            .frame(width: 8)       // ← must match the dot’s width

                        Text(starOrConstText)
                            .font(.custom("CormorantInfant-SemiBold", size: 11))
                            .foregroundColor(Color.mediumOrchid)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.center)
                            .padding(.leading, post.postType == "completion" ? 13 : 32)  // mirror tiny gap above
                    }
                    .frame(maxWidth: 332)
                }
                .offset(x: 24, y: 24)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 17)
            .padding(.bottom, 17)

        }
        .padding(.top, 30)
        .frame(height: 244)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
    }
    
}
    


struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post:postDummyData[0])
    }
}
