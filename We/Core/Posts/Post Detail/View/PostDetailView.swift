//
//  PostDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/19/24.
//

import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var postId: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if let post = authViewModel.selectedPost {
                    Text(post.title)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.leading)
                    
                    Text("By \(post.username)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                    
                    Text(post.content)
                        .font(.callout)
                        .multilineTextAlignment(.leading)
                } else {
                    Text("Loading...")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .toolbar {
                // Bookmark Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if let post = authViewModel.selectedPost {
                            authViewModel.toggleBookmarkPost(postId: post.id)
                        }
                    }) {
                        Label(authViewModel.isBookmarked ? "Remove Bookmark" : "Bookmark", systemImage: authViewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    }
                }
                
                // More Options Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Add functionality for more options
                    } label: {
                        Label("More", systemImage: "ellipsis")
                    }
                }
            }
        }
        .navigationTitle(authViewModel.selectedPost?.board.title ?? "Post Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            authViewModel.checkIfPostIsBookmarked(postId: postId)
            authViewModel.fetchPost(by: postId)
        }
        .alert(isPresented: $authViewModel.showAlert) {
            Alert(title: Text("Notification"), message: Text(authViewModel.errorMessage ?? "Message"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(postId: "67202a3e91dfa7246a92f59f")
            .environmentObject(AuthViewModel())
    }
}
