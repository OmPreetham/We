//
//  ActivityView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/5/24.
//

import SwiftUI

struct ActivityView: View {
    @State private var selectedPicker = 0
        
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
                    PostListView(posts: samplePosts)
                } else if selectedPicker == 1 {
                    PostListView(posts: samplePosts)
                } else if selectedPicker == 2 {
                    PostListView(posts: samplePosts)
                } else {
                    PostListView(posts: samplePosts)
                }
            }
            .navigationTitle("Activity")
        }
    }
}

#Preview {
    ActivityView()
}
