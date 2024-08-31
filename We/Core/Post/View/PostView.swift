//
//  PostView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

enum SortOption {
    case newToOld
    case oldToNew
    case mostUpvotes
    case mostDownvotes
}

struct PostView: View {
    @State private var isExpanded: Bool = false
    @State private var sortOption: SortOption = .newToOld
    @State private var showingCreate: Bool = false
    
    var post: Post
    var board: Board {
        Board.mockBoards.first { $0.id == post.boardId }!
    }
    
    var user: User {
        User.mockUsers.first { $0.id == post.userID }!
    }
    
    var onUpvotePressed: (() -> Void)?
    var onDownvotePressed: (() -> Void)?
    var onReplyPressed: (() -> Void)?
    var onBookmarkPressed: (() -> Void)?
    var onEllipsisPressed: (() -> Void)?
    
    var replies: [Post] {
        Post.mockPosts.filter { $0.parentPostID == post.id }
    }
    
    var parentPost: Post? {
        guard let parentID = post.parentPostID else { return nil }
        return Post.mockPosts.first { $0.id == parentID }
    }
    
    var sortedReplies: [Post] {
        switch sortOption {
        case .newToOld:
            return replies.sorted { $0.timestamp > $1.timestamp }
        case .oldToNew:
            return replies.sorted { $0.timestamp < $1.timestamp }
        case .mostUpvotes:
            return replies.sorted { $0.upvotes > $1.upvotes }
        case .mostDownvotes:
            return replies.sorted { $0.downvotes > $1.downvotes }
        }
    }
    
    let imageNames = ["eva","eva-2", "eva-3", "eva-4"]
    @State var selectedImage = 0
    @State private var showingMediaViewer: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if let parent = parentPost {
                        PostCell(post: parent, hasParentPost: true)
                            .padding(.bottom, 8)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            EclipseProfileImageView(community: board, size: .small)
                            
                            VStack(alignment: .leading) {
                                Text(board.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                HStack(spacing: 4) {
                                    Text(user.username)
                                    Text("·")
                                    Text(post.timestamp.formatted(date: .abbreviated, time: .standard))
                                }
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Button {
                                onEllipsisPressed?()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.foreground)
                            }
                        }
                        .padding(.trailing, 4)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(post.content)
                                .font(.subheadline)
                                .lineLimit(isExpanded ? nil : 4)
                                .multilineTextAlignment(.leading)
                                .animation(.easeInOut, value: isExpanded)
                            
                            if post.content.count > 250 {
                                Button {
                                    withAnimation {
                                        isExpanded.toggle()
                                    }
                                } label: {
                                    Text(isExpanded ? "Show Less" : "Show More")
                                        .font(.subheadline)
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                        
                        ScrollMediaView(imageNames: imageNames, selectedImage: $selectedImage, showingMediaViewer: $showingMediaViewer)
                        
                        HStack {
                            Button {
                                onUpvotePressed?()
                            } label: {
                                Label("\(post.upvotes)", systemImage: "arrowshape.up")
                            }
                            
                            Spacer()
                            
                            Button {
                                onDownvotePressed?()
                            } label: {
                                Label("\(post.downvotes)", systemImage: "arrowshape.down")
                            }
                            
                            Spacer()
                            
                            Button {
                                showingCreate.toggle()
                            } label: {
                                Label("\(replies.count)", systemImage: "bubble.right")
                            }
                            
                            Spacer()
                            
                            Button {
                                onBookmarkPressed?()
                            } label: {
                                Image(systemName: "bookmark")
                            }
                        }
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .padding(.horizontal, 12)
                    
                    if !replies.isEmpty {
                        VStack {
                            Divider()
                                .foregroundStyle(.quinary)

                            HStack {
                                Text("Replies")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Menu {
                                    Picker("Sort by", selection: $sortOption) {
                                        Label("Newest First", systemImage: "arrow.up").tag(SortOption.newToOld)
                                        Label("Oldest First", systemImage: "arrow.down").tag(SortOption.oldToNew)
                                        Label("Top Upvotes", systemImage: "hand.thumbsup.fill").tag(SortOption.mostUpvotes)
                                        Label("Top Downvotes", systemImage: "hand.thumbsdown.fill").tag(SortOption.mostDownvotes)
                                    }
                                } label: {
                                    Label("Sort By", systemImage: "line.3.horizontal.decrease.circle")
                                        .font(.callout)
                                        .foregroundStyle(.foreground)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            
                            Divider()
                                .foregroundStyle(.quinary)
                        }
                        
                        LazyVStack {
                            ForEach(sortedReplies) { reply in
                                NavigationLink(value: reply.id) {
                                    PostCell(post: reply)
                                }
                                .foregroundStyle(.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle(board.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { postID in
                if let selectedPost = Post.mockPosts.first(where: { $0.id == postID }) {
                    PostView(post: selectedPost)
                } else {
                    ContentUnavailableView("Post Unavailable", systemImage: "rectangle.slash.fill", description: Text("Post not found"))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        ShareLink("", item: "")
                    }
                }
            }
            .sheet(isPresented: $showingCreate) {
                CreatePostView(replyPost: post, communityID: board.id)
            }
            .refreshable {
                print("DEBUG: Refresh")
            }
        }
        .safeAreaInset(edge: .bottom) {
            TriggerButton(title: "Add a reply...", systemName: "quote.bubble.fill", trigger: $showingCreate)
                .padding(8)
        }
    }
}

#Preview {
    PostView(post: Post.mockPosts[1])
}
