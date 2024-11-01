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
    
    @State private var isFollowing: Bool = false
    @State private var showingEditSheet: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            PostListView(posts: samplePosts)
        }
        .navigationTitle(authViewModel.selectedBoard?.title ?? "Board Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Follow/Unfollow Button
                Button {
                    handleToggleFollow()
                } label: {
                    Label(isFollowing ? "Unfollow" : "Follow", systemImage: isFollowing ? "checkmark" : "plus")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.bordered)
                .clipShape(.circle)
                .accessibilityLabel(isFollowing ? "Unfollow" : "Follow")
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if isAdminOrModerator {
                    Button(action: {
                        showingEditSheet = true
                    }) {
                        Label("Edit", systemImage: "slider.horizontal.3")
                            .font(.callout)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.bordered)
                    .clipShape(.circle)
                    .accessibilityLabel("Edit Board")
                }
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: authViewModel.followedBoards) {
            checkIfFollowing()
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
    
    // Load initial data
    private func loadData() {
        isLoading = true
        authViewModel.fetchBoard(by: boardId)
        authViewModel.fetchFollowedBoards {
            self.checkIfFollowing()
            isLoading = false
        }
    }
    
    // Check if the user is following this board
    private func checkIfFollowing() {
        guard let board = authViewModel.selectedBoard else {
            isFollowing = false
            return
        }
        isFollowing = authViewModel.followedBoards.contains { $0.id == board.id }
    }
    
    // Handle toggle follow action
    private func handleToggleFollow() {
        guard let board = authViewModel.selectedBoard else { return }
        authViewModel.toggleFollowBoard(boardId: board.id)
    }
    
    // Check if user has admin or moderator role
    private var isAdminOrModerator: Bool {
        guard let role = authViewModel.currentUser?.role else { return false }
        return role.lowercased() == "admin" || role.lowercased() == "moderator"
    }
}

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BoardDetailView(boardId: "6716d55d9384d14d52370eec")
                .environmentObject(AuthViewModel())
        }
    }
}
