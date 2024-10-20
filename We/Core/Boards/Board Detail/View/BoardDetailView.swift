//
//  BoardDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/20/24.
//

import SwiftUI

struct BoardDetailView: View {
    @Environment(\.dismiss) var dismiss

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
        .sheet(isPresented: $showingEditBoard) {
            EditBoardView(title: $boardItem.title, description: $boardItem.description, symbolColor: $boardItem.symbolColor, systemImageName: $boardItem.systemImageName)
        }
        .refreshable {
            
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
