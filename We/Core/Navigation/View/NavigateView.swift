//
//  NavigateView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/18/24.
//

import SwiftUI

struct NavigateView: View {
    @State private var primarySelection: PrimarySelection? = .forYou
    @State private var selectedPostId: Post.ID?
    @State private var searchText = ""
    
    enum PrimarySelection: Hashable {
        case profile
        case forYou
        case followingPosts
        case board(Board.ID)
        case explore(String)
        case settings
    }
    
    var body: some View {
        NavigationSplitView {
            // Menu in the primary column
            List(selection: $primarySelection) {
                // Profile section at the top
                Section {
                    ProfileHeaderView()
                        .onTapGesture {
                            primarySelection = .profile
                        }
                }
                .listRowInsets(EdgeInsets()) // Remove extra padding
                
                // Home Section
                Section(header: Text("Home")) {
                    NavigationLink(value: PrimarySelection.forYou) {
                        Text("For You")
                    }
                    NavigationLink(value: PrimarySelection.followingPosts) {
                        Text("Following")
                    }
                }

                // Boards Section
                Section(header: Text("Boards")) {
                    ForEach(sampleBoards) { board in
                        NavigationLink(value: PrimarySelection.board(board.id)) {
                            Text(board.title)
                        }
                    }
                }

                // Explore Section
                Section(header: Text("Explore")) {
                    NavigationLink(value: PrimarySelection.explore("University")) {
                        Text("Explore University")
                    }
                }

                // Settings Section
                Section(header: Text("Settings")) {
                    NavigationLink(value: PrimarySelection.settings) {
                        Text("Settings")
                    }
                }
            }
            .navigationTitle("We")
            .searchable(text: $searchText)
        } content: {
            // Content section based on selection
            if let selection = primarySelection {
                switch selection {
                case .profile:
                    ProfileView()
                case .forYou:
                    // 'For You' section with styled posts
                    PostListViewV(posts: samplePosts, selectedPostId: $selectedPostId)
                        .navigationTitle("For You")
                case .followingPosts:
                    // 'Following Posts' section with styled posts
                    PostListViewV(posts: samplePosts, selectedPostId: $selectedPostId)
                        .navigationTitle("Following")
                case .board(let boardId):
                    // Posts related to the selected board
                    if let board = sampleBoards.first(where: { $0.id == boardId }) {
                        let postsInBoard = samplePosts.filter { $0.board == boardId }
                        PostListViewV(posts: postsInBoard, selectedPostId: $selectedPostId)
                            .navigationTitle(board.title)
                    } else {
                        Text("Board not found")
                    }
                case .explore(let exploreOption):
                    // Placeholder for explore content
                    Text("Explore \(exploreOption)")
                        .navigationTitle("Explore")
                case .settings:
                    // Settings section
                    SettingsView()
                }
            } else {
                Text("Select an item")
            }
        } detail: {
            // Detail view for selected post
            if let postId = selectedPostId,
               let post = samplePosts.first(where: { $0.id == postId }) {
                PostDetailView(post: post)
            } else {
                Text("Select a post")
            }
        }
    }
}

// Profile header view with a more visually appealing design
struct ProfileHeaderView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    Text("Shinji Ikari")
                        .font(.title2)
                        .bold()
                    
                    Text("@ShinjiIkariUnit01")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .cornerRadius(10)
    }
}

// A view to display profile-related information (posts, replies, upvotes/downvotes)
struct ProfileViewV: View {
    var body: some View {
        List {
            Section(header: Text("Your Posts")) {
                ForEach(samplePosts) { post in
                    Text(post.title)
                }
            }

            Section(header: Text("Replies")) {
                // Add your replies data here
                Text("No replies yet")
            }

            Section(header: Text("Upvotes & Downvotes")) {
                // Add upvote/downvote tracking if needed
                Text("Upvoted Posts: 5")
                Text("Downvoted Posts: 2")
            }
        }
    }
}

// A separate view to display the list of posts with navigation to post details
struct PostListViewV: View {
    var posts: [Post]
    @Binding var selectedPostId: Post.ID?
    
    var body: some View {
        List(posts) { post in
            // NavigationLink to navigate to the post detail view
            NavigationLink(destination: PostDetailView(post: post), tag: post.id, selection: $selectedPostId) {
                HStack(alignment: .top) {
                    // Board image (you can replace this placeholder with actual images)
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .padding(.trailing, 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .top) {
                            // Board title
                            Text(boardTitle(for: post.board))
                                .font(.headline)
                            
                            // Username
                            Text(post.username)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        // Post title
                        Text(post.title)
                            .font(.body)
                            .bold()
                            .lineLimit(1)
                        
                        // Post content (limited to 4 lines)
                        Text(post.content)
                            .font(.body)
                            .lineLimit(2)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    // Helper function to get the board title from the board ID
    func boardTitle(for boardId: String) -> String {
        if let board = sampleBoards.first(where: { $0.id == boardId }) {
            return board.title
        }
        return "Unknown Board"
    }
}

// Post detail view
struct PostDetailView: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By \(post.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(post.content)
                .font(.body)
            Spacer()
        }
        .padding()
        .navigationTitle(post.title)
    }
}

#Preview {
    NavigateView()
}
