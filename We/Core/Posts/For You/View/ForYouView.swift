//
//  ForYouView.swift
//  We
//
//  Created by Om Preetham Bandi on 11/1/24.
//

import SwiftUI

struct ForYouView: View {
    var posts: [Post]
    
    @State private var searchText: String = ""
    @State var showingCreatePost: Bool = false
    
    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return posts
        } else {
            return posts.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.content.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if filteredPosts.isEmpty && posts.isEmpty {
                    ContentUnavailableView("No Posts Available", systemImage: "rectangle.stack", description: Text("No posts to show right now."))
                } else if filteredPosts.isEmpty {
                    ProgressView("Loading...")
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(filteredPosts, id: \.id) { post in
                                NavigationLink(destination: PostDetailView(post: post)) {
                                    PostPreviewCell(post: post)
                                }
                                .foregroundStyle(.foreground)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .navigationTitle("For You")
            .toolbar {
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
                        .font(.caption2)
                        
                        Spacer()
                        
                        Button(action: {
                            showingCreatePost.toggle()
                        }) {
                            Label("New Post", systemImage: "square.and.pencil")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView()
            }
            .refreshable {
                // Add refresh logic if necessary
            }
            .searchable(text: $searchText, prompt: "Search Posts")
        }
    }
}

#Preview {
    ForYouView(posts: samplePosts)
        .environmentObject(AuthViewModel())
}
