//
//  HomeView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct HomeView: View {
    let options = ["For You", "Following"]
    @State private var selectedOption = "For You"
    
    @State private var showingCreatePost: Bool = false
    @State private var showingProfile: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                Picker("Options", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                            .tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                PostListView(posts: samplePosts)
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingProfile.toggle()
                    } label: {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .buttonStyle(.borderless)
                }
                
                ToolbarItem {
                    Button {
                        showingCreatePost.toggle()
                    } label: {
                        Label("Post", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView()
            }
        }
    }
}

#Preview {
    HomeView()
}
