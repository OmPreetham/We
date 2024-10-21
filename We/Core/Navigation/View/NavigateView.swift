//
//  NavigateView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/18/24.
//

import SwiftUI

struct NavigateView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var primarySelection: PrimarySelection? = .forYou
    @State private var selectedPostId: Post.ID?
    @State private var searchText = ""
    @State private var isShowingCreatePost = false

    enum PrimarySelection: Hashable {
        case account
        case forYou
        case followingPosts
        case board(Board.ID)
    }
    
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            NavigationSidebarView(primarySelection: $primarySelection)
                .environmentObject(authViewModel)
        } content: {
            NavigationContentView(
                primarySelection: $primarySelection,
                isShowingCreatePost: $isShowingCreatePost
            )
        } detail: {
            NavigationDetailView(selectedPostId: $selectedPostId)
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    NavigateView()
        .environmentObject(AuthViewModel())
}
