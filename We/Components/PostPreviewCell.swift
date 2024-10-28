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
        ZStack {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    Rectangle()
                        .fill(Color(hex: post.board.symbolColor).materialActiveAppearance(.active))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Image(systemName: post.board.systemImageName)
                        .foregroundStyle(.primary)
                }
                .frame(width: 50, height: 50)
                .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)

                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(post.board.title)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            
                            Text(post.username)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                        
                        Text(post.createdAt.relativeDate())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(post.title)

                            Text(post.content)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                    }
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

#Preview {
    PostPreviewCell(
        post: Post(
            id: "610cda503b0f5a001e86534c",
            title: "Best Study Spots on Campus?",
            content: "Looking for the best quiet places to study...",
            user: sampleUsers[0],
            username: "@AnonStudent",
            parentPost: nil,
            path: ",",
            upvoteCount: 1500,
            downvoteCount: 20,
            commentCount: 120,
            viewCount: 1000,
            board: sampleBoards[0],
            createdAt: Date(),
            updatedAt: Date()
        )
    )
}
