//
//  FollowingPostsView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/28/24.
//

import SwiftUI

struct FollowingPostsView: View {
    @StateObject private var followingPostsViewModel = FollowingPostsViewModel()
    
    @State private var showingCreatePost: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if followingPostsViewModel.isLoadingFollowingPosts {
                    ProgressView()
                } else if followingPostsViewModel.followingPosts.isEmpty {
                    ContentUnavailableView("No Following Posts", systemImage: "star.slash.fill", description: Text("You haven't followed any boards yet."))
                } else {
                    PostListView(posts: followingPostsViewModel.followingPosts)
                }
            }
            .navigationTitle("Following")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
                            print("Filter button tapped")
                        }) {
                            Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(followingPostsViewModel.lastUpdatedText)
                            Text(DateFormatter.localizedString(from: followingPostsViewModel.lastUpdated ?? Date(), dateStyle: .none, timeStyle: .short))
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
                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                if followingPostsViewModel.followingPosts.isEmpty {
                    followingPostsViewModel.fetchFollowingPosts()
                }
            }
            .refreshable {
                followingPostsViewModel.fetchFollowingPosts()
            }
            .alert(isPresented: $followingPostsViewModel.showAlert) {
                Alert(title: Text("Following Posts Alert"), message: Text(followingPostsViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    FollowingPostsView()
}
