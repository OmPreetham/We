//
//  PostPreviewCell.swift
//  We
//
//  Created by Om Preetham Bandi on 10/7/24.
//

import SwiftUI

struct PostPreviewCell: View {
    let post: Post
    let board: Board
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                Image(systemName: board.systemImageName)
                    .frame(width: 50, height: 50)
                    .background(Color(hex: board.symbolColor))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        // Add action for image tap if needed
                    }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 8) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(board.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            
                            Text(post.username)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                        
                        Text(post.createdAt.relativeDate())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.title)
                            .font(.headline)
                            .fontDesign(.serif)
                            .fontWeight(.bold)

                            Text(post.content)
                                .font(.body)
                                .lineLimit(8)
                                .truncationMode(.tail)
                                .overlay(
                                    Label("Read More", systemImage: "greaterthan")
                                        .labelStyle(.iconOnly)
                                        .font(.callout)
                                        .foregroundStyle(.teal)
                                        .padding(.bottom, 4)
                                        .opacity(post.content.count > 360 ? 1 : 0),
                                    alignment: .bottomTrailing
                                )
                                .lineSpacing(2)
                    }
                    .multilineTextAlignment(.leading)
                    
                    HStack {
                        Button {
                            // Action for reply button
                        } label: {
                            Label("Comment", systemImage: "message")
                                .labelStyle(.iconOnly)
                            
                            Text(String(post.commentCount))
                        }
                        
                        Spacer()
                        
                        Button {
                            // Action for upvote button
                        } label: {
                            Label("Upvote", systemImage: "hand.thumbsup")
                                .labelStyle(.iconOnly)
                            
                            Text(String(post.upvoteCount))
                        }
                        
                        Spacer()
                        
                        Button {
                            // Action for downvote button
                        } label: {
                            Label("Downvote", systemImage: "hand.thumbsdown")
                                .labelStyle(.iconOnly)
                            
                            Text(String(post.downvoteCount))
                        }
                        
                        Spacer()
                        
                        Button {
                            // Action for bookmark button
                        } label: {
                            Label("Bookmark", systemImage: "bookmark")
                                .labelStyle(.iconOnly)
                        }
                    }
                    .foregroundStyle(.secondary)
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
            content: "Looking for quiet places to study...",
            user: "610cd1cf3b0f5a001e86534b",
            username: "@AnonStudent",
            parentPost: nil,
            path: ",",
            upvoteCount: 1500,
            downvoteCount: 20,
            commentCount: 120,
            viewCount: 1000,
            board: "610cf9e03b0f5a001e86534d",
            createdAt: Date(),
            updatedAt: Date()
        ),
        board: Board(
            id: "610cf9e03b0f5a001e86534d",
            title: "Study Board",
            description: "A board dedicated to finding great study spots",
            symbolColor: "#FF5733", // Orange color
            systemImageName: "books.vertical",
            userId: "610cd1cf3b0f5a001e86534b"
        )
    )
}
