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
        VStack{
            HStack{
                //            Image("temp")
                Text("Image goes here later")
                VStack{
                    Text(post.displayName)
                    Text("\(post.postTime.convertToAgo())")
                }
            }
            Text("Constellation goes here")
            Text(post.message)
            Text("\(post.studyDuration.formattedHumanReadable())")
            

        }
        .background(Color.gray)
        .cornerRadius(15) 
    }
}
    


struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post:dummyData[0])
    }
}
