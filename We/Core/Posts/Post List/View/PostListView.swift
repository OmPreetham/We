//
//  PostListView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/7/24.
//

import SwiftUI

struct PostListView: View {
    let posts: [Post] // Accept posts as an input parameter
    let boards: [Board] = sampleBoards // Use a static list for boards or pass dynamically if needed
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if posts.isEmpty {
                    ContentUnavailableView("No posts found", systemImage: "square.3.layers.3d.down.backward.slash.rtl", description: Text("No post found. Please create a post to see it here."))                } else {
                    ForEach(posts) { post in
                        if let board = boards.first(where: { $0.id == post.board }) {
                            PostPreviewCell(post: post, board: board)
                                .padding(8)
                            
                            Divider()
                                .frame(height: 1)
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

#Preview {
    PostListView(posts: samplePosts)
}
