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
//    var cellWidth: CGFloat = 128
//    let cellHeight: CGFloat = 128

    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            //stack for the information at the top
            // MARK: - The top section of information
            HStack(alignment: .top){
                HStack(alignment: .center, spacing: 12) {
//                    Image("star_fade")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 45, height: 45)
                    Circle()
                        .fill(Color.mediumOrchid)
                        .frame(width: 45, height: 45)
                    
                    VStack(alignment: .leading, spacing: 2){
                        Text(post.displayName)
                            .font(.custom("CormorantInfant-Bold", size: 27))
                            .foregroundColor(Color.warmPurple)
                        
                        Text(post.postTime.formattedTimestamp())
                            .font(.custom("CormorantInfant-SemiBold", size: 12))
                            .foregroundColor(Color.warmPurple)
                    }
                }
                Spacer()
                
                // VStack for "working on.." and "big dipper" (Right side)
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("working on..")
                                    .font(.custom("CormorantInfant-SemiBold", size: 16)) // Slightly larger font
                                    .foregroundColor(Color.mediumOrchid)
                                
                                Text("big dipper")
                                    .font(.custom("CormorantInfant-Bold", size: 27))
                                    .foregroundColor(Color.warmPurple)
                            }
                
            }.padding(.horizontal, 24)
            
            //the rest
            Text(post.message)
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
                    .fill(Color.veryLightPurple)
                    .padding(3.74)
                
                VStack(spacing: 4){
                    HStack(spacing:20){
                        Text("\(post.studyDuration.formattedHHMM())")
                            .font(.custom("CormorantInfant-SemiBold", size: 50))
                            .foregroundColor(Color.mediumOrchid)
                            .padding(.leading, 64)
                        Text("•")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color.mediumOrchid)
                        Image("star_feed")
                            .resizable()
                            .frame(width: 50, height: 64)
                            .padding(.trailing, 64)
                        
                    }
                    
                    HStack(alignment: .top) {
                        Text("time completed")
                            .font(.custom("CormorantInfant-SemiBold", size: 11))
                            .foregroundColor(Color.mediumOrchid)
                            .padding(.leading, 79)
                        
                        Spacer()

                        Text("1/7 sessions") // Hardcoded, replace with relevant session count
                            .font(.custom("CormorantInfant-SemiBold", size: 11))
                            .foregroundColor(Color.mediumOrchid)
                            .padding(.trailing, 65)
                    }
                    .frame(width:332)
                }
                
                
            }
            .padding(.vertical, 16) // Padding inside the ZStack content
            .padding(.horizontal, 17)
            .padding(.bottom, 17)
        }
        .padding(.top, 30)
        .frame(height: 244)
        .frame(maxWidth: .infinity)
        .background(Color.veryLightPurple)
    }
    
}
    


struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post:postDummyData[0])
    }
}
