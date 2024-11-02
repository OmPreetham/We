//
//  ForYouView.swift
//  We
//
//  Created by Om Preetham Bandi on 11/1/24.
//

import SwiftUI

struct ForYouView: View {
    var posts: [Post]
    
    @State var showingCreatePost: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if posts.isEmpty {
                    ContentUnavailableView("No Posts Available", systemImage: "sharedwithyou.slash", description: Text("No posts to show right now."))
                } else {
                    PostListView(posts: posts)
                }
            }
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
        }
    }
}

#Preview {
    ForYouView(posts: samplePosts)
        .environmentObject(AuthViewModel())
}
