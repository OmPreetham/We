//
//  BoardDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/20/24.
//

import SwiftUI

struct BoardDetailView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    @StateObject private var viewModel: BoardDetailViewModel
    
    @State private var showingEditSheet: Bool = false
    @State private var showingCreatePost: Bool = false
    
    init(boardId: String, authViewModel: AuthViewModel) {
        _viewModel = StateObject(wrappedValue: BoardDetailViewModel(authViewModel: authViewModel, boardId: boardId))
    }

    var body: some View {
        ZStack {
            if viewModel.isLoadingBoardPosts {
                ProgressView()
            } else {
                VStack {
                    if viewModel.boardPosts.isEmpty {
                        ContentUnavailableView("No Posts", systemImage: "square.stack.3d.up.slash.fill", description: Text("No posts are available for this Board"))
                    } else {
                        PostListView(posts: viewModel.boardPosts)
                    }
                }
            }
        }
        .navigationTitle(viewModel.selectedBoard?.title ?? "Board Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleFollowBoard()
                } label: {
                    Label(viewModel.isFollowing ? "Unfollow" : "Follow", systemImage: viewModel.isFollowing ? "checkmark" : "plus")
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
        .sheet(isPresented: $showingEditSheet) {
            if let board = viewModel.selectedBoard {
                EditBoardView(
                    title: .constant(board.title),
                    description: .constant(board.description),
                    symbolColor: .constant(board.symbolColor),
                    systemImageName: .constant(board.systemImageName)
                )
                .environmentObject(authViewModel)
                .onDisappear {
                    viewModel.loadBoardData()
                }
            }
        }
        .sheet(isPresented: $showingCreatePost) {
            if let board = viewModel.selectedBoard {
                CreatePostView(selectedBoard: board)
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Alert"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
    
    private var isAdminOrModerator: Bool {
        guard let role = authViewModel.currentUser?.role else { return false }
        return role.lowercased() == "admin" || role.lowercased() == "moderator"
    }
}

#Preview {
    NavigationView {
        BoardDetailView(boardId: "6720220991dfa7246a92ef7c", authViewModel: AuthViewModel())
            .environmentObject(AuthViewModel())
    }
}
