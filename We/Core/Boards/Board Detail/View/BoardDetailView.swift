//
//  BoardDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/20/24.
//

import SwiftUI

struct BoardDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var boardId: String

    @State private var showingEditSheet: Bool = false
    @State private var showingCreatePost: Bool = false
    @State private var isLoading: Bool = false
    @State private var lastLoadedBoardId: String?

    private var isFollowing: Bool {
        guard let board = authViewModel.selectedBoard else { return false }
        return authViewModel.followedBoards.contains { $0.id == board.id }
    }

    var body: some View {
        ZStack {
            if authViewModel.isLoadingBoardPosts {
                ProgressView()
            } else {
                VStack {
                    if authViewModel.boardPosts.isEmpty {
                        ContentUnavailableView("No Posts", systemImage: "square.stack.3d.up.slash.fill", description: Text("No posts are available for this Board"))
                    } else {
                        PostListView(posts: authViewModel.boardPosts)
                    }
                }
            }
        }
        .navigationTitle(authViewModel.selectedBoard?.title ?? "Board Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    handleToggleFollow()
                } label: {
                    Label(isFollowing ? "Unfollow" : "Follow", systemImage: isFollowing ? "checkmark" : "plus")
                        .labelStyle(.titleOnly)
                }
                .buttonStyle(.bordered)
                .clipShape(.capsule)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if isAdminOrModerator {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "slider.horizontal.3")
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(.circle)
                    .padding(.trailing, -8)
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
                        Text("Updated Just Now")
                        Text("02:00 PM")
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
        .onAppear {
            if lastLoadedBoardId != boardId {
                loadData()
            }
        }
        .refreshable {
            loadData()
        }
        .sheet(isPresented: $showingEditSheet) {
            if let board = authViewModel.selectedBoard {
                EditBoardView(
                    boardId: board.id,
                    title: board.title,
                    description: board.description,
                    symbolColor: board.symbolColor,
                    systemImageName: board.systemImageName
                )
                .environmentObject(authViewModel)
                .onDisappear {
                    authViewModel.fetchBoard(by: board.id)
                }
            }
        }
        .sheet(isPresented: $showingCreatePost) {
            if let board = authViewModel.selectedBoard {
                CreatePostView(selectedBoard: board)
                    .presentationDetents([.medium, .large])
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { authViewModel.errorMessage != nil },
            set: { _ in authViewModel.errorMessage = nil }
        )) {
            Alert(title: Text("Alert"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadData() {
        isLoading = true
        lastLoadedBoardId = boardId
        authViewModel.fetchBoard(by: boardId)
        authViewModel.fetchBoardPosts(for: boardId)
    }
    
    private func handleToggleFollow() {
        guard let board = authViewModel.selectedBoard else { return }
        authViewModel.toggleFollowBoard(boardId: board.id)
    }
    
    private var isAdminOrModerator: Bool {
        guard let role = authViewModel.currentUser?.role else { return false }
        return role.lowercased() == "admin" || role.lowercased() == "moderator"
    }
}

#Preview {
    NavigationView {
        BoardDetailView(boardId: "6720220991dfa7246a92ef7c")
            .environmentObject(AuthViewModel())
    }
}
