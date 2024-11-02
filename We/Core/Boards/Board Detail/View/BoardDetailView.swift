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
    @State private var isLoading: Bool = false

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
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if isAdminOrModerator {
                    Button(action: {
                        showingEditSheet = true
                    }) {
                        Label("Edit", systemImage: "ellipsis")
                    }
                }
            }
        }
        .onAppear {
            loadData()
        }
        .refreshable {
            loadData()
        }
        .sheet(isPresented: $showingEditSheet) {
            if let board = authViewModel.selectedBoard {
                EditBoardView(
                    title: .constant(board.title),
                    description: .constant(board.description),
                    symbolColor: .constant(board.symbolColor),
                    systemImageName: .constant(board.systemImageName)
                )
                .environmentObject(authViewModel)
                .onDisappear {
                    authViewModel.fetchBoard(by: boardId)
                }
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
        authViewModel.fetchBoard(by: boardId)
        authViewModel.fetchBoardPosts(for: boardId)
        authViewModel.fetchFollowedBoards()
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
