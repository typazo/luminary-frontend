//
//  PostCell.swift
//  luminary-frontend
//
//  Created by Tyler on 11/22/25.
//

import SwiftUI

struct PostCell: View {
    var post: Post
    var cellWidth: CGFloat = 128
    let cellHeight: CGFloat = 128

    var body: some View {
        Text(post.displayName)
                .font(.system(size: 100, weight: .regular, design: .rounded))
                .foregroundColor(.black)
                .frame(width: cellWidth, alignment: .leading)
    }
}



struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post:dummyData[0])
    }
}
