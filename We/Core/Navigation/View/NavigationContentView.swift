//
//  NavigationContentView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/19/24.
//

import SwiftUI

struct NavigationContentView: View {
    @Binding var primarySelection: NavigateView.PrimarySelection?
    @Binding var isShowingCreatePost: Bool

    var body: some View {
        if let selection = primarySelection {
            switch selection {
            case .account:
                AccountView()
                    .navigationTitle("Profile")
            case .forYou:
                PostListContainerView(
                    title: "For You",
                    posts: samplePosts,
                    isShowingCreatePost: $isShowingCreatePost
                )
            case .followingPosts:
                PostListContainerView(
                    title: "Following",
                    posts: samplePosts,
                    isShowingCreatePost: $isShowingCreatePost
                )
            case .board(let boardId):
                BoardDetailView(boardId: boardId)
            }
        } else {
            Text("Select an item")
        }
    }
}
