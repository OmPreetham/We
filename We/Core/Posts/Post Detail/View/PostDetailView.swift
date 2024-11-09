//
//  PostDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/19/24.
//

import SwiftUI

struct PostDetailView: View {
    @StateObject private var viewModel = PostDetailViewModel()
    
    @State var showingCreatePost: Bool = false

    var postId: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let post = viewModel.post {
                    VStack(alignment: .leading, spacing: 8) {
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
                    }
                    .padding()

                    Divider()

                    // Replies Section
                    if viewModel.isLoadingReplies {
                        ProgressView("Loading replies...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if !viewModel.replies.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Replies")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(viewModel.replies) { reply in
                                NavigationLink(destination: PostDetailView(postId: reply.id)) {
                                    PostPreviewCell(post: reply)
                                }
                                .foregroundStyle(.foreground)
                            }
                        }
                    } else {
                        Text("No replies yet.")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                } else if viewModel.isLoadingPost {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ContentUnavailableView("Post Not Found", systemImage: "text.page.slash.fill", description: Text("Post is not available. Please try again later."))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .toolbar {
                // Bookmark Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.toggleBookmarkPost(postId: postId)
                    }) {
                        Label(viewModel.isBookmarked ? "Remove Bookmark" : "Bookmark", systemImage: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    }
                }

                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
                            print("Filter button tapped")
                        }) {
                            Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(viewModel.lastUpdatedText)
                            Text(DateFormatter.localizedString(from: viewModel.lastUpdated ?? Date(), dateStyle: .none, timeStyle: .short))
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
        }
        .navigationTitle(viewModel.post?.board.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingCreatePost) {
            CreatePostView()
        }
        .onAppear {
            viewModel.checkIfPostIsBookmarked(postId: postId)
            viewModel.fetchPost(by: postId)
            viewModel.fetchPostReplies(postId: postId)
        }
        .refreshable {
            viewModel.checkIfPostIsBookmarked(postId: postId)
            viewModel.fetchPost(by: postId)
            viewModel.fetchPostReplies(postId: postId)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Post Alert"), message: Text(viewModel.errorMessage ?? "Message"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(postId: "672eb44ea04e8cdea10c86c9")
    }
}
