//
//  HomeView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showingCreate: Bool = false
    @State private var selectedMode: String = "Trending"
    
    let filterOptions = ["Trending", "Recent", "Popular"]
    
    var posts: [Post] = Post.mockPosts
    var community: Community? = Community.mockCommunities[0]

    var body: some View {
        NavigationStack {
            headerSection(title: "We", options: filterOptions, selected: $selectedMode, action: $showingCreate)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.vertical) {
                postList(of: posts)
            }
            .navigationTitle("We")
            .toolbar(.hidden, for: .navigationBar)
            .padding(.top, -24)
            .refreshable {
                print("DEBUG: Refresh Posts")
            }
            .navigationDestination(for: Post.self) { post in
                PostView(post: post)
            }
            .sheet(isPresented: $showingCreate) {
                CreatePostView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

private func headerSection(title: String, options: [String], selected: Binding<String>, action: Binding<Bool>) -> some View {
    HStack {
        Text(title)
            .font(.system(size: 44))
            .fontWeight(.bold)
            .foregroundStyle(.blue)
            .fontDesign(.serif)
            .shadow(radius: 4)
        
        Menu {
            ForEach(options, id: \.self) { option in
                Button {
                    selected.wrappedValue = option
                } label: {
                    Text(option)
                }
            }
        } label: {
            HStack {
                Text(selected.wrappedValue)
                
                Image(systemName: "arrow.down")
            }
            .fontWeight(.bold)
            .foregroundStyle(.foreground.opacity(0.4))
        }
        
        Spacer()
    
        Button {
            action.wrappedValue.toggle()
        } label: {
            Image(systemName: "plus")
        }
        .foregroundStyle(.primary)
        .font(.title2)

    }
    .padding(.horizontal)
}

private func postList(of posts: [Post]) -> some View {
    LazyVStack {
        ForEach(posts, id: \.id) { post in
            NavigationLink(value: post) {
                PostCell(post: post)
            }
            .foregroundStyle(.primary)
        }
    }
}

#Preview {
    HomeView()
}
