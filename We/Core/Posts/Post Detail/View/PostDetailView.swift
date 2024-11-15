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
    @State private var showingReportSheet = false
    @State private var reportReason = ""
    
    var postId: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Display parent post if it exists
                if let parentPost = viewModel.parentPost {
                    NavigationLink(destination: PostDetailView(postId: parentPost.id)) {
                        PostPreviewCell(post: parentPost)
                    }
                    .foregroundStyle(.foreground)
                    
                    Divider()
                }
                
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

                    // Upvote and Downvote Buttons
                    HStack(spacing: 40) {
                        Button(action: {
                            viewModel.upvotePost(postId: postId)
                        }) {
                            HStack {
                                Image(systemName: "hand.thumbsup.fill")
                                Text("\(post.upvoteCount)")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.downvotePost(postId: postId)
                        }) {
                            HStack {
                                Image(systemName: "hand.thumbsdown.fill")
                                Text("\(post.downvoteCount)")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.toggleBookmarkPost(postId: postId)
                        }) {
                            Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                        }
                    }
                    .font(.headline)
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
        }
        .navigationTitle(viewModel.post?.board.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchPost(by: postId)
            viewModel.checkIfPostIsBookmarked(postId: postId)
            viewModel.fetchPostReplies(postId: postId)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Report Post") {
                        showingReportSheet = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingReportSheet) {
            ReportPostSheetView(reportReason: $reportReason, postId: postId)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Post Alert"), message: Text(viewModel.errorMessage ?? "Message"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(postId: "672f23333453b558ef1eb8d2")
    }
}
