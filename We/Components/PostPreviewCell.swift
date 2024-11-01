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
        VStack(alignment: .leading, spacing: 8) {
            // Title
            Text(post.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            // Content
            Text(post.content)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
            
            // Board, Username, and Date Info
            HStack(alignment: .center, spacing: 8) {
                // Board Pill
                HStack(spacing: 4) {
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: post.board.symbolColor).materialActiveAppearance(.active))
                            .clipShape(.circle)
                        
                        Image(systemName: post.board.systemImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.background)
                    }
                    .frame(width: 20, height: 20)
                    
                    Text(post.board.title)
                        .font(.footnote)
                        .foregroundStyle(.primary)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .lineLimit(1)
                .truncationMode(.tail)
                
                // Anonymous User Pill
                Text(post.username)
                    .font(.footnote)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // Time Pill
                Text(post.createdAt.relativeDate())
                    .font(.caption)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    PostPreviewCell(post: samplePosts[0])
}
