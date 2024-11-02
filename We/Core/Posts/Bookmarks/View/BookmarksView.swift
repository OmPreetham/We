//
//  BookmarksView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/28/24.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingCreatePost: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if authViewModel.isLoadingBookmarkPosts {
                    ProgressView()
                } else if authViewModel.bookmarkPosts.isEmpty {
                    ContentUnavailableView("No Bookmarks", systemImage: "bookmark.slash.fill", description: Text("You haven't bookmarked any posts yet."))
                } else {
                    PostListView(posts: authViewModel.bookmarkPosts)
                }
            }
            .navigationTitle("Bookmarks")
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
                if authViewModel.bookmarkPosts.isEmpty {
                    authViewModel.fetchBookmarkPosts()
                }
            }
            .refreshable {
                authViewModel.fetchBookmarkPosts()
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
    BookmarksView()
        .environmentObject(AuthViewModel())
}
