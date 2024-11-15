//
//  ForYouViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/15/24.
//

import Foundation
import Combine

class ForYouViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var forYouPosts: [Post] = []
    @Published var isLoadingForYouPosts: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var lastUpdated: Date?
    
    private let postService = PostService.shared
    
    // MARK: - Computed Property for Last Updated Text
    var lastUpdatedText: String {
        return lastUpdated?.timeAgo ?? "Updated a long time ago"
    }
    
    // MARK: - Fetch For You Posts
    func fetchForYouPosts() {
        isLoadingForYouPosts = true
        errorMessage = nil
        showAlert = false
        
        postService.fetchForYouPosts { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingForYouPosts = false
                self?.lastUpdated = Date() // Set last updated time
                switch result {
                case .success(let posts):
                    self?.forYouPosts = posts
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}
