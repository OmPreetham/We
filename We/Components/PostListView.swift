//
//  PostListView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/7/24.
//

import SwiftUI

struct PostListView: View {
    let posts: [Post]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(posts, id: \.id) { post in
                    NavigationLink(destination: PostDetailView(postId: post.id)) {
                        PostPreviewCell(post: post)
                    }
                    .foregroundStyle(.foreground)
                }
            }
        }
    }
}

#Preview {
    PostListView(posts: samplePosts)
}
