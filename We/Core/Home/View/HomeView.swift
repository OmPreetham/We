//
//  HomeView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showingCreate: Bool = false
    @State private var selectedMode: String = "Trending"
    
    let filterOptions = ["Trending", "Recent", "Popular"]
    
    var posts: [Post] = Post.mockPosts
    var community: Board? = Board.mockBoards[0]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                postList(of: posts)
            }
            .navigationTitle("Home")
            .navigationDestination(for: Post.self) { post in
                PostView(post: post)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        ForEach(filterOptions, id: \.self) { option in
                            Button {
                                selectedMode = option
                            } label: {
                                Text(option)
                            }
                        }
                    } label: {
                        Label(selectedMode, systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingCreate.toggle()
                    } label: {
                        Label("New Post", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreate) {
                CreatePostView()
                    .presentationDetents([.medium, .large])
            }
            .refreshable {
                print("DEBUG: Refresh Posts")
            }
        }
    }
}

private func postList(of posts: [Post]) -> some View {
    LazyVStack {
        ForEach(posts, id: \.id) { post in
            NavigationLink(value: post) {
                PostCell(post: post)
            }
            .foregroundStyle(.primary)
        }
    }
}

#Preview {
    HomeView()
}
