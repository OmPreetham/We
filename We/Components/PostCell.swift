//
//  PostCell.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct PostCell: View {
    var post: Post
    var organisation: Organization {
        Organization.mockOrganizations.first { $0.id == post.organisationID }!
    }
    var user: User {
        User.mockUsers.first { $0.id == post.userID }!
    }
    var hasParentPost: Bool?
    
    var replies: [Post] {
        // Filter posts to get replies to the current post
        Post.mockPosts.filter { $0.parentPostID == post.id }
    }
    
    var onUpvotePressed: (() -> Void)?
    var onDownvotePressed: (() -> Void)?
    var onReplyPressed: (() -> Void)?
    var onBookmarkPressed: (() -> Void)?
    var onEllipsisPressed: (() -> Void)?
    
    var body: some View {
        NavigationLink(destination: PostView(post: post)) {
            VStack {
                HStack(alignment: .top, spacing: 4) {
                    VStack {
                        CircularProfileImageView(organisation: organisation, size: .small)
                        
                        Rectangle()
                            .opacity(hasParentPost ?? false ? 1 : 0)
                            .frame(width: 2)
                            .foregroundStyle(.tertiary)
                    }
                    
                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
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
                                .lineLimit(4)
                                .multilineTextAlignment(.leading)
                            
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
                                
                                Button {
                                    
                                } label: {
                                    ShareLink("", item: "")
                                }
                            }
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        }
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 8)
                        
                        if !(hasParentPost ?? false) {
                            Divider()
                                .background(.tertiary)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .padding(.leading)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PostCell(post: Post.mockPosts[0])
}
