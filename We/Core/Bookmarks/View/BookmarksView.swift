//
//  BookmarksView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/6/24.
//

import SwiftUI

struct BookmarksView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                PostListView(posts: samplePosts)
            }
            .navigationTitle("Bookmarks")
        }
    }
}

#Preview {
    BookmarksView()
}
