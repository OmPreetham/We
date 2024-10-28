//
//  FollowingPostsView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/28/24.
//

import SwiftUI

struct FollowingPostsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText: String = ""
    @State private var showingCreatePost: Bool = false
    
    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return authViewModel.followingPosts
        } else {
            return authViewModel.followingPosts.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.content.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            if authViewModel.isLoadingFollowingPosts {
                ProgressView("Loading...")
                    .navigationTitle("Following Posts")
            } else if filteredPosts.isEmpty {
                VStack {
                    Text("No posts available.")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .navigationTitle("Following Posts")
            } else {
                PostListContainerView(title: "Following Posts", posts: filteredPosts, isShowingCreatePost: $showingCreatePost)
                .searchable(text: $searchText, prompt: "Search Posts")
                .refreshable {
                    authViewModel.fetchFollowingPosts()
                }
            }
        }
        .refreshable {
            authViewModel.fetchFollowingPosts()
        }
        .onAppear {
            if authViewModel.followingPosts.isEmpty {
                authViewModel.fetchFollowingPosts()
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { authViewModel.errorMessage != nil },
            set: { _ in authViewModel.errorMessage = nil }
        )) {
            Alert(title: Text("Error"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    FollowingPostsView()
        .environmentObject(AuthViewModel())
}
