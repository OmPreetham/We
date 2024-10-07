//
//  PostListView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/7/24.
//

import SwiftUI

struct PostListView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                PostPreviewCell()
                PostPreviewCell()
                PostPreviewCell()
                PostPreviewCell()
                PostPreviewCell()
                PostPreviewCell()
            }
            .padding(.horizontal, 4)
        }
    }
}

#Preview {
    PostListView()
}
