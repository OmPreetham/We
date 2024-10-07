//
//  BookmarksView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/6/24.
//

import SwiftUI

struct BookmarksView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                PostListView()
            }
            .navigationTitle("Bookmarks")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark.circle.fill")
                            .labelStyle(.titleOnly)
                    }
                }
            }
        }
    }
}

#Preview {
    BookmarksView()
}
