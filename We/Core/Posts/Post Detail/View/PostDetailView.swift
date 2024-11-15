//
//  PostDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/19/24.
//

import SwiftUI

struct PostDetailView: View {
    @StateObject private var postDetailViewModel = PostDetailViewModel()
    
    @State private var showingReplyToPost: Bool = false
    @State private var showingReportSheet = false
    @State private var reportReason = ""
    
    var postId: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Display parent post if it exists
                if let parentPost = postDetailViewModel.parentPost {
                    NavigationLink(destination: PostDetailView(postId: parentPost.id)) {
                        PostPreviewCell(post: parentPost)
                    }
                    .foregroundStyle(.foreground)
                    
                    Divider()
                }
                
                if let post = postDetailViewModel.post {
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
                            postDetailViewModel.upvotePost(postId: postId)
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
                            postDetailViewModel.downvotePost(postId: postId)
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
                            postDetailViewModel.toggleBookmarkPost(postId: postId)
                        }) {
                            Image(systemName: postDetailViewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                        }
                    }
                    .font(.headline)
                    .padding()

                    Divider()

                    // Replies Section
                    if postDetailViewModel.isLoadingReplies {
                        ProgressView("Loading replies...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if !postDetailViewModel.replies.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Replies")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(postDetailViewModel.replies) { reply in
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
                } else if postDetailViewModel.isLoadingPost {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ContentUnavailableView("Post Not Found", systemImage: "text.page.slash.fill", description: Text("Post is not available. Please try again later."))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(postDetailViewModel.post?.board.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            postDetailViewModel.fetchPost(by: postId)
            postDetailViewModel.checkIfPostIsBookmarked(postId: postId)
            postDetailViewModel.fetchPostReplies(postId: postId)
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
                        Text(postDetailViewModel.lastUpdatedText)
                        Text(DateFormatter.localizedString(from: postDetailViewModel.lastUpdated ?? Date(), dateStyle: .none, timeStyle: .short))
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption2)
                    
                    Spacer()
                    
                    Button(action: {
                        showingReplyToPost.toggle()
                    }) {
                        Label("Reply to Post", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .sheet(isPresented: $showingReplyToPost) {
            ReplyPostView(postId: postId)
        }
        .sheet(isPresented: $showingReportSheet) {
            ReportPostSheetView(reportReason: $reportReason, postId: postId)
        }
        .alert(isPresented: $postDetailViewModel.showAlert) {
            Alert(title: Text("Post Alert"), message: Text(postDetailViewModel.errorMessage ?? "Message"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(postId: "672f23333453b558ef1eb8d2")
    }
}
