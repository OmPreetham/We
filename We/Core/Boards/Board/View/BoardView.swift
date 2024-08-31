//
//  BoardView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/10/24.
//

import SwiftUI

struct BoardView: View {
    @State private var showingCreate: Bool = false
    
    var board: Board
    
    var boardPosts: [Post] {
        Post.mockPosts.filter { $0.boardId == board.id }
    }
    
    var body: some View {
        ZStack {
            if !boardPosts.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach(boardPosts) { post in
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
                        if #available(iOS 17.0, *) {
                            ContentUnavailableView("Post Unavailable", systemImage: "rectangle.slash.fill", description: Text("Post not found"))
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            } else {
                ContentUnavailableView("No Posts", systemImage: "square.3.layers.3d.down.right.slash", description: Text("There are no posts available for \(board.name) Community."))
            }
        }
        .navigationTitle(board.name)
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
            CreatePostView(communityID: board.id)
        }
        .refreshable {
            print("DEBUG: Refresh")
        }
    }
}

#Preview {
    BoardView(board: Board.mockBoards[1])
}
