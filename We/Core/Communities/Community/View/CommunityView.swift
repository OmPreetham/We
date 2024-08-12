//
//  CommunityView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/10/24.
//

import SwiftUI

struct CommunityView: View {
    @State private var showingCreate: Bool = false
    
    var community: Community
    
    var communityPosts: [Post] {
        Post.mockPosts.filter { $0.communityID == community.id }
    }
    
    var body: some View {
        ZStack {
            if !communityPosts.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach(communityPosts) { post in
                            NavigationLink(value: post.id) {
                                PostCell(post: post)
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }
                .navigationDestination(for: String.self) { postID in
                    if let selectedPost = Post.mockPosts.first(where: { $0.id == postID }) {
                        PostView(post: selectedPost)
                    } else {
                        ContentUnavailableView("Post Unavailable", systemImage: "rectangle.slash.fill", description: Text("Post not found"))
                    }
                }
            } else {
                ContentUnavailableView("No Posts", systemImage: "square.3.layers.3d.down.right.slash", description: Text("There are no posts available for \(community.name) Community."))
            }
        }
        .navigationTitle(community.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingCreate.toggle()
                } label: {
                    Label("New Post", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreate) {
            CreateView()
        }
    }
}

#Preview {
    CommunityView(community: Community.mockCommunities[1])
}
