//
//  BoardDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct BoardDetailView: View {
    @Environment(\.dismiss) var dismiss

    @State private var showingCreatePost: Bool = false
    @State private var followingBoard = false
    @State private var showingEditBoard = false
    
    @State var boardItem: Board
    let posts: [Post]

    var boardPosts: [Post] {
        posts.filter { $0.board == boardItem.id }
    }

    var body: some View {
        ZStack {
            VStack {
                if boardPosts.isEmpty {
                    Text("No posts available for this board.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    PostListView(posts: boardPosts) // Display filtered posts for the board
                }
            }
            
            Button {
                showingCreatePost.toggle()
            } label: {
                Label("New Post", systemImage: "plus")
                    .font(.caption)
            }
            .padding(16)
            .foregroundStyle(.primary)
            .background(Color.teal.gradient.materialActiveAppearance(.automatic))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .offset(x: -20, y: -20)
        }
        .navigationTitle(boardItem.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    followingBoard.toggle()
                } label: {
                    if followingBoard {
                        Label("Unfollow", systemImage: "checkmark.circle.fill")
                    } else {
                        Label("Follow", systemImage: "plus")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingEditBoard.toggle()
                } label: {
                    Label("Edit", systemImage: "slider.horizontal.3")
                }
            }
        }
        .sheet(isPresented: $showingCreatePost) {
            CreatePostView(selectedBoard: boardItem)
        }
        .sheet(isPresented: $showingEditBoard) {
            EditBoardView(title: $boardItem.title, description: $boardItem.description, symbolColor: $boardItem.symbolColor, systemImageName: $boardItem.systemImageName)
        }
    }
}

#Preview {
    BoardDetailView(
        boardItem: Board(
            id: "610cf9e03b0f5a001e86534d",
            title: "Board Title",
            description: "Board Description",
            userId: "user_id",
            symbolColor: "#FF5733",
            systemImageName: "books.vertical"
        ),
        posts: samplePosts
    )
}
