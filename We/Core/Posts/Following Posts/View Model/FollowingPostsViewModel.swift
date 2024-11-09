//
//  FollowingPostsViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/9/24.
//

import Foundation
import Combine

class FollowingPostsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var followingPosts: [Post] = []
    @Published var isLoadingFollowingPosts: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var lastUpdated: Date?
    
    private let postService = PostService.shared
    
    // MARK: - Computed Property for Last Updated Text
    var lastUpdatedText: String {
        return lastUpdated?.timeAgo ?? "Updated a long time ago"
    }
    
    // MARK: - Fetch Following Posts
    func fetchFollowingPosts() {
        isLoadingFollowingPosts = true
        errorMessage = nil
        showAlert = false
        
        postService.fetchFollowingPosts { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingFollowingPosts = false
                self?.lastUpdated = Date() // Set last updated time
                switch result {
                case .success(let posts):
                    self?.followingPosts = posts
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}
