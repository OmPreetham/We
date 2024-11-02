//
//  FollowingPostsView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/28/24.
//

import SwiftUI

struct FollowingPostsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingCreatePost: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if authViewModel.isLoadingFollowingPosts {
                    ProgressView()
                } else if authViewModel.followingPosts.isEmpty {
                    ContentUnavailableView("No Following Posts", systemImage: "star.slash.fill", description: Text("You haven't followed any boards yet."))
                } else {
                    PostListView(posts: authViewModel.followingPosts)
                }
            }
            .navigationTitle("Following Posts")
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
            .onAppear {
                if authViewModel.followingPosts.isEmpty {
                    authViewModel.fetchFollowingPosts()
                }
            }
            .refreshable {
                authViewModel.fetchFollowingPosts()
            }
            .alert(isPresented: Binding<Bool>(
                get: { authViewModel.errorMessage != nil },
                set: { _ in authViewModel.errorMessage = nil }
            )) {
                Alert(title: Text("Alert"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    FollowingPostsView()
        .environmentObject(AuthViewModel())
}
