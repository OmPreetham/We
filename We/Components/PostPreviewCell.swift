//
//  PostPreviewCell.swift
//  We
//
//  Created by Om Preetham Bandi on 10/7/24.
//

import SwiftUI

struct PostPreviewCell: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(post.content)
                    .font(.subheadline)
                    .lineLimit(9)
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            
            Divider()
            
            HStack(alignment: .center) {
                Label(post.board.title, systemImage: post.board.systemImageName)
                
                Spacer()
                
                Text(post.username)
                
                Spacer()
                
                Text(post.createdAt.relativeDate())
            }
            .font(.footnote)
            .lineLimit(1)
            .truncationMode(.tail)
            .foregroundStyle(.secondary)
            .fontWeight(.medium)
            .padding(4)
        }
        .padding(8)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
        .padding(.horizontal)
    }
}

#Preview {
    PostPreviewCell(post: samplePosts[2])
}
