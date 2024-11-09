//
//  PostDetailViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/9/24.
//

import Foundation

class PostDetailViewModel: ObservableObject {
    @Published var post: Post?
    @Published var replies: [Post] = []
    @Published var isLoadingPost: Bool = false
    @Published var isLoadingReplies: Bool = false
    @Published var isBookmarked: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false

    private let authService = AuthService.shared

    func fetchPost(by postId: String) {
        isLoadingPost = true
        errorMessage = nil

        authService.fetchPostById(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingPost = false
                switch result {
                case .success(let post):
                    self?.post = post
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }

    func fetchPostReplies(postId: String) {
        isLoadingReplies = true
        errorMessage = nil

        authService.fetchPostReplies(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingReplies = false
                switch result {
                case .success(let replies):
                    self?.replies = replies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }

    func toggleBookmarkPost(postId: String) {
        authService.toggleBookmarkPost(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.isBookmarked.toggle()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }

    func checkIfPostIsBookmarked(postId: String) {
        authService.isPostBookmarked(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isBookmarked):
                    self?.isBookmarked = isBookmarked
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}
