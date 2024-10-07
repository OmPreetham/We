//
//  ProfileView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/5/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

    @State private var showingBookmarks = false
    @State private var selectedPicker = 0
    
    @State private var username: String = "OmPreetham"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Picker("Select Content", selection: $selectedPicker) {
                    Text("Posts").tag(0)
                    Text("Replies").tag(1)
                    Text("Upvotes").tag(2)
                    Text("Downvotes").tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if selectedPicker == 0 {
                    PostListView()
                } else if selectedPicker == 1 {
                    PostListView()
                } else if selectedPicker == 2 {
                    PostListView()
                } else {
                    PostListView()
                }
            }
            .navigationTitle(username)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingBookmarks.toggle()
                    } label: {
                        Label("Bookmarks", systemImage: "bookmark.fill")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark.circle.fill")
                            .labelStyle(.titleOnly)
                    }
                }
            }
            .sheet(isPresented: $showingBookmarks) {
                BookmarksView()
            }
        }
    }
}

#Preview {
    ProfileView()
}
