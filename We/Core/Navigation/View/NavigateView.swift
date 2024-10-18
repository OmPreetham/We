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
    @State private var isShowingCreatePost = false // State to control new post sheet
    @State private var showingSettings: Bool = false
    
    enum PrimarySelection: Hashable {
        case profile
        case forYou
        case followingPosts
        case board(Board.ID)
    }
    
    var body: some View {
        NavigationSplitView {
            // Menu in the primary column
            List(selection: $primarySelection) {
                // Profile section at the top
                Section {
                    ProfileHeaderView()
                        .background(.secondary.opacity(0.0001))
                        .onTapGesture {
                            primarySelection = .profile
                        }
                }
                .listRowInsets(EdgeInsets()) // Remove extra padding
                
                // Home Section
                Section(header: Text("Personalized")) {
                    NavigationLink(value: PrimarySelection.forYou) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color.teal.gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Image(systemName: "shared.with.you")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 50, height: 50)
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                            .padding(.trailing, 8)

                            VStack(alignment: .leading) {
                                Text("For You")
                                    .font(.headline)
                                
                                Text("This is a sample text that will be replaced with a description of the board.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .lineLimit(2)
                        }
                    }
                    NavigationLink(value: PrimarySelection.followingPosts) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color(red: 212/255, green: 175/255, blue: 55/255).gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 50, height: 50)
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                            .padding(.trailing, 8)

                            VStack(alignment: .leading) {
                                Text("Following")
                                    .font(.headline)
                                
                                Text("This is a sample text that will be replaced with a description of the board.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .lineLimit(2)
                        }
                    }
                }
                
                // Boards Section
                Section(header: Text("Boards")) {
                    ForEach(sampleBoards) { board in
                        NavigationLink(value: PrimarySelection.board(board.id)) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.init(hex: board.symbolColor).gradient)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    Image(systemName: board.systemImageName)
                                        .foregroundStyle(.white)
                                }
                                .frame(width: 50, height: 50)
                                .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                                .padding(.trailing, 8)

                                VStack(alignment: .leading) {
                                    Text(board.title)
                                        .font(.headline)
                                    
                                    Text(board.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .lineLimit(3)
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("III")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings.toggle()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        } content: {
            // Content section based on selection
            if let selection = primarySelection {
                switch selection {
                case .profile:
                    ProfileViewV()
                        .navigationTitle("Profile")
                case .forYou:
                    // 'For You' section with styled posts and floating buttons
                    ZStack {
                        PostListViewV(posts: samplePosts, selectedPostId: $selectedPostId)
                            .navigationTitle("For You")
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            HStack {
                                // Filter button aligned to the left
                                Button(action: {
                                    // Add action for filter functionality
                                    print("Filter button tapped")
                                }) {
                                    Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                                }
                                
                                Spacer() // Pushes the New Post button to the right
                                
                                // New Post button aligned to the right
                                Button(action: {
                                    // Show the Create Post view
                                    isShowingCreatePost.toggle()
                                }) {
                                    Label("New Post", systemImage: "square.and.pencil")
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingCreatePost) {
                        CreatePostView()
                    }
                case .followingPosts:
                    // 'Following Posts' section with styled posts
                    ZStack {
                        PostListViewV(posts: samplePosts, selectedPostId: $selectedPostId)
                            .navigationTitle("Following")
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            HStack {
                                // Filter button aligned to the left
                                Button(action: {
                                    // Add action for filter functionality
                                    print("Filter button tapped")
                                }) {
                                    Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                                }
                                
                                Spacer() // Pushes the New Post button to the right
                                
                                // New Post button aligned to the right
                                Button(action: {
                                    // Show the Create Post view
                                    isShowingCreatePost.toggle()
                                }) {
                                    Label("New Post", systemImage: "square.and.pencil")
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingCreatePost) {
                        CreatePostView()
                    }
                case .board(let boardId):
                    // Posts related to the selected board
                    if let board = sampleBoards.first(where: { $0.id == boardId }) {
                        let postsInBoard = samplePosts.filter { $0.board == boardId }
                        PostListViewV(posts: postsInBoard, selectedPostId: $selectedPostId)
                            .navigationTitle(board.title)
                    } else {
                        Text("Board not found")
                    }
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
            HStack(spacing: 8) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    Text("ShinjiIkariUnit01")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Profile, Personalization, Settings, and More")
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
                        HStack(alignment: .top, spacing: 4) {
                            VStack(alignment: .leading) {
                                // Board title
                                Text(boardTitle(for: post.board))
                                    .font(.headline)
                                
                                // Username
                                Text(post.username)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(post.createdAt.formatted(date: .abbreviated, time: .standard))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        // Post title
                        Text(post.title)
                            .font(.body)
                            .fontWeight(.regular)
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
