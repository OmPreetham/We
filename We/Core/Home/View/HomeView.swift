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
    
    let filterOptions = ["Trending", "Recent"]
    
    var posts: [Post] = Post.mockPosts
    var community: Board? = Board.mockBoards[0]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    Section {
                        postList(of: posts)
                    } header: {
                        Picker("Sort Posts", selection: $selectedMode) {
                            ForEach(filterOptions, id: \.self) { option in
                                Text(option)
                                    .tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
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
            NavigationLink(destination: PostView(post: post)) {
                PostCell(post: post)
            }
            .foregroundStyle(.primary)
        }
    }
}

#Preview {
    HomeView()
}
