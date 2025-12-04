//
//  PostCell.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import SwiftUI
//TODO: Implement the difference between a constelation and a star completion. No point in starting until I can see the design. Will implement this with an if statement that changes the view depending on the "constelation" / "star" string passed in.


extension Date {
    func formattedTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a  •  MM/dd/yy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        // Lowercase the AM/PM part
        let result = formatter.string(from: self)
        return result
    }
    
}

struct PostCell: View {
    var post: Post
//    var cellWidth: CGFloat = 128
//    let cellHeight: CGFloat = 128

    var body: some View {
        VStack{
            //stack for the information at the top
            HStack{
                Image("star_fade")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                VStack{
                    Text(post.displayName)
                        .font(.custom("CormorantInfant-Bold", size: 27))
                        .foregroundColor(Color.warmPurple)
                    
                    Text(post.postTime.formattedTimestamp())
                        .font(.custom("CormorantInfant-SemiBold", size: 12))
                        .foregroundColor(Color.warmPurple)
                }
            }
            
            
            
            //the rest
            Text(post.message)
                .font(.custom("CormorantInfant-SemiBold", size: 12))
                .foregroundColor(Color.warmPurple)
                
            
            Text("\(post.studyDuration.formattedHumanReadable())")
                .font(.custom("CormorantInfant-SemiBold", size: 12))
                
            

        }
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
