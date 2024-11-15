//
//  ForYouView.swift
//  We
//
//  Created by Om Preetham Bandi on 11/1/24.
//

import SwiftUI

struct ForYouView: View {
    @StateObject private var forYouPostsViewModel = ForYouViewModel()
    
    @State private var showingCreatePost: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if forYouPostsViewModel.isLoadingForYouPosts {
                    ProgressView()
                } else if forYouPostsViewModel.forYouPosts.isEmpty {
                    ContentUnavailableView("No For You Posts", systemImage: "star.slash.fill", description: Text("You haven't interacted with any boards or posts yet."))
                } else {
                    PostListView(posts: forYouPostsViewModel.forYouPosts)
                }
            }
            .navigationTitle("For You")
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
                            Text(forYouPostsViewModel.lastUpdatedText)
                            Text(DateFormatter.localizedString(from: forYouPostsViewModel.lastUpdated ?? Date(), dateStyle: .none, timeStyle: .short))
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
                if forYouPostsViewModel.forYouPosts.isEmpty {
                    forYouPostsViewModel.fetchForYouPosts()
                }
            }
            .refreshable {
                forYouPostsViewModel.fetchForYouPosts()
            }
            .alert(isPresented: $forYouPostsViewModel.showAlert) {
                Alert(title: Text("For You Posts Alert"), message: Text(forYouPostsViewModel.errorMessage ?? "Something went wrong."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    ForYouView()
}
