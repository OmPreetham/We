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
    case mostLiked
    case mostUpvotes
    case mostDownvotes
}

struct PostView: View {
    @State private var isExpanded: Bool = false
    @State private var sortOption: SortOption = .newToOld
    
    var post: Post
    var organisation: Organization {
        Organization.mockOrganizations.first { $0.id == post.organisationID }!
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
        // Filter posts to get replies to the current post
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
        case .mostLiked:
            return replies.sorted { ($0.upvotes - $0.downvotes) > ($1.upvotes - $1.downvotes) }
        case .mostUpvotes:
            return replies.sorted { $0.upvotes > $1.upvotes }
        case .mostDownvotes:
            return replies.sorted { $0.downvotes > $1.downvotes }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let parent = parentPost {
                    PostCell(post: parent, hasParentPost: true)
                        .padding(.bottom, 8)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        CircularProfileImageView(organisation: organisation, size: .small)

                        VStack(alignment: .leading) {
                            Text(organisation.name)
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

                    Text(post.content)
                        .font(.subheadline)
                        .lineLimit(isExpanded ? nil : 4)
                        .multilineTextAlignment(.leading)
                        .animation(.easeInOut, value: isExpanded)
                    
                    HStack(spacing: 8) {
                        Button {
                            onUpvotePressed?()
                        } label: {
                            Label("\(post.upvotes)", systemImage: "arrowshape.up")
                        }
                        
                        Button {
                            onDownvotePressed?()
                        } label: {
                            Label("\(post.downvotes)", systemImage: "arrowshape.down")
                        }
                        
                        Button {
                            onReplyPressed?()
                        } label: {
                            Label("\(replies.count)", systemImage: "bubble.right")
                        }
                                                
                        Spacer()
                        
                        Button {
                            onBookmarkPressed?()
                        } label: {
                            Image(systemName: "bookmark")
                        }
                        
                        if post.content.count > 250 {
                            Button {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            } label: {
                                Text(isExpanded ? "Show Less" : "Show More")
                                    .font(.subheadline)
                                    .foregroundStyle(.teal)
                            }
                        }
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                }
                .foregroundStyle(.primary)
                .padding(.horizontal, 12)
                
                VStack {
                    Divider()
                        .foregroundStyle(.tertiary)
                    
                    HStack {
                        Text("Replies")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Menu {
                            Picker("Sort by", selection: $sortOption) {
                                Text("New to Old").tag(SortOption.newToOld)
                                Text("Old to New").tag(SortOption.oldToNew)
                                Text("Most Liked").tag(SortOption.mostLiked)
                                Text("Most Upvotes").tag(SortOption.mostUpvotes)
                                Text("Most Downvotes").tag(SortOption.mostDownvotes)
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
                        .foregroundStyle(.tertiary)
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
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: String.self) { postID in
            if let selectedPost = Post.mockPosts.first(where: { $0.id == postID }) {
                PostView(post: selectedPost)
            } else {
                Text("Post not found")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    ShareLink("", item: "")
                }
            }
        }
    }
}

#Preview {
    PostView(post: Post.mockPosts[1])
}
