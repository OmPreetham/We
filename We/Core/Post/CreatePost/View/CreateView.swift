//
//  CreatePostView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var caption = ""
    @State private var selectedCommunity: Board
    
    var replyPost: Post?
    var communityID: String?
    
    var communities: [Board] = Board.mockBoards
    var user: User = User.mockUsers[0]
    
    init(replyPost: Post? = nil, communityID: String? = nil) {
        self.replyPost = replyPost
        self.communityID = communityID
        _selectedCommunity = State(initialValue: Board.mockBoards.first { $0.id == communityID } ?? Board.mockBoards[0])
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let post = replyPost {
                        PostCell(post: post, hasParentPost: true, hasActions: false)
                            .disabled(true)
                    }
                }
                
                VStack {
                    HStack(alignment: .top, spacing: 0) {
                        CircularProfileImageView(community: selectedCommunity, size: .medium)
                            .offset(y: 8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 2) {
                                Picker("Select Community", selection: $selectedCommunity) {
                                    ForEach(communities, id: \.id) { community in
                                        Text(community.name.capitalized)
                                            .tag(community)
                                    }
                                }
                                .pickerStyle(.menu)
                                
                                Text(user.username)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                if !caption.isEmpty {
                                    Button {
                                        caption = ""
                                    } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .tint(.red)
                                            .frame(width: 12, height: 12)
                                    }
                                }
                            }
                            
                            TextField("Start writing", text: $caption, axis: .vertical)
                                .padding(.leading, 12)
                                .multilineTextAlignment(.leading)
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.horizontal)
                .navigationTitle((replyPost != nil) ? "Reply Post" : "New Post")
                .navigationBarTitleDisplayMode(.inline)
                .interactiveDismissDisabled()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                        .font(.subheadline)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button((replyPost != nil) ? "Add Reply" : "Post") {
                            // Add your post logic here
                            dismiss()
                        }
                        .opacity(caption.isEmpty ? 0.5 : 1)
                        .disabled(caption.isEmpty)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    CreatePostView()
}
