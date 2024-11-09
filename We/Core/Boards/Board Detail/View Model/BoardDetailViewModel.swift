//
//  BoardDetailViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/9/24.
//

import Foundation
import Combine

class BoardDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedBoard: Board?
    @Published var boardPosts: [Post] = []
    @Published var isLoadingBoardPosts: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var isFollowing: Bool = false

    private var authViewModel: AuthViewModel
    private var boardId: String
    private var cancellables = Set<AnyCancellable>()

    init(authViewModel: AuthViewModel, boardId: String) {
        self.authViewModel = authViewModel
        self.boardId = boardId
        loadBoardData()
    }
    
    // MARK: - Load Data

    func loadBoardData() {
        isLoadingBoardPosts = true
        errorMessage = nil
        showAlert = false
        
        fetchBoard()
        fetchBoardPosts()
    }

    private func fetchBoard() {
        BoardService.shared.fetchBoardById(boardId: boardId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let board):
                    self?.selectedBoard = board
                    self?.isFollowing = self?.authViewModel.followedBoards.contains { $0.id == board.id } ?? false
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
    
    private func fetchBoardPosts() {
        BoardService.shared.fetchBoardPosts(for: boardId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingBoardPosts = false
                switch result {
                case .success(let posts):
                    self?.boardPosts = posts
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }

    // MARK: - Follow/Unfollow Board

    func toggleFollowBoard() {
        guard let board = selectedBoard else { return }
        BoardService.shared.toggleFollowBoard(boardId: board.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isFollowing.toggle()
                    self?.authViewModel.fetchFollowedBoards() // Update followed boards in authViewModel
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}
