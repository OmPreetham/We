//
//  PostListView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/7/24.
//

import SwiftUI

struct PostListView: View {
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    PostPreviewCell()
                    PostPreviewCell()
                    PostPreviewCell()
                    PostPreviewCell()
                    PostPreviewCell()
                    PostPreviewCell()
                }
                .padding(.horizontal, 16)
            }
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 0)
        }
    }
}

#Preview {
    PostListView()
}
