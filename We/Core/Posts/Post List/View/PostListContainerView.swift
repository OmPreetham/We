//
//  PostListContainerView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/19/24.
//

import SwiftUI

struct PostListContainerView: View {
    var title: String
    var posts: [Post]
    
    @State private var followingBoard = false
    
    @Binding var isShowingCreatePost: Bool
    
    var selectedBoard: Board? = nil

    var body: some View {
        ZStack {
            PostListView(posts: posts)
                .navigationTitle(title)
        }
        .toolbar {
            if selectedBoard != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        followingBoard.toggle()
                    } label: {
                        if followingBoard {
                            Label("Following", systemImage: "checkmark.circle.fill")
                                .labelStyle(.titleAndIcon)
                        } else {
                            Label("Follow", systemImage: "plus")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                    .font(.subheadline)
                    .buttonStyle(.bordered)
                    .clipShape(.capsule)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button(action: {
                        // Add action for filter functionality
                        print("Filter button tapped")
                    }) {
                        Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Updated Just Now")
                        Text("02:00 PM")
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingCreatePost.toggle()
                    }) {
                        Label("New Post", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingCreatePost) {
            CreatePostView(selectedBoard: selectedBoard)
        }
        .refreshable {
            
        }
    }
}
