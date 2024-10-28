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
        List(posts, id: \.id) { post in
            if let board = sampleBoards.first(where: { $0.id == post.board }) {
                NavigationLink(destination: PostDetailView(post: post)) {
                    PostPreviewCell(post: post, board: board)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    PostListView(posts: samplePosts)
}
