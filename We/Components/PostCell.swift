//
//  PostCell.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct PostCell: View {
    @State private var showingCreate: Bool = false

    var post: Post
    var community: Board {
        Board.mockBoards.first { $0.id == post.boardId }!
    }
    var user: User {
        User.mockUsers.first { $0.id == post.userID }!
    }
    
    var hasParentPost: Bool?
    var replies: [Post] {
        Post.mockPosts.filter { $0.parentPostID == post.id }
    }
    
    var hasActions: Bool = true
    
    var onUpvotePressed: (() -> Void)?
    var onDownvotePressed: (() -> Void)?
    var onBookmarkPressed: (() -> Void)?
    var onEllipsisPressed: (() -> Void)?
    var onNamePressed: (() -> Void)?
    
    let imageNames = ["eva","eva-2", "eva-3", "eva-4"]
    @State var selectedImage = 0
    @State private var showingMediaViewer: Bool = false
    
    var body: some View {
        NavigationLink(destination: PostView(post: post)) {
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    VStack {
                        CircularProfileImageView(community: community, size: .small)
                        
                        Rectangle()
                            .opacity(hasParentPost ?? false ? 1 : 0)
                            .frame(width: 2)
                            .foregroundStyle(.tertiary)
                    }
                    
                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text(community.name)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .onTapGesture {
                                            onNamePressed?()
                                        }
                                    
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
                            
                            ScrollMediaView(imageNames: imageNames, selectedImage: $selectedImage, showingMediaViewer: $showingMediaViewer)
                            
                            if hasActions {
                                HStack(spacing: 20) {
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
                                    
                                    Button {
                                        
                                    } label: {
                                        ShareLink("", item: "")
                                    }
                                }
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, 8)
                        
                        if !(hasParentPost ?? false) {
                            Divider()
                                .background(.tertiary)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .padding(.leading, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingCreate) {
            CreatePostView(replyPost: post, communityID: community.id)
        }
    }
}

#Preview {
    PostCell(post: Post.mockPosts[0])
}
