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
        GroupBox {
            Text(post.content)
                .font(.subheadline)
                .lineLimit(9)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .padding(.bottom, 2)
            
            HStack(alignment: .center) {
                Label(post.board.title, systemImage: post.board.systemImageName)
                
                Spacer()
                
                Text(post.username)
                
                Spacer()
                
                Text(post.createdAt.relativeDate())
            }
            .font(.caption2)
            .fontWeight(.medium)
            .lineLimit(1)
            .truncationMode(.tail)
            .foregroundStyle(.secondary)
        } label: {
            Text(post.title)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

#Preview {
    PostPreviewCell(post: samplePosts[2])
}
