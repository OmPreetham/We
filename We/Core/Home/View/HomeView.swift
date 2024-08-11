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
            HStack {
                Group {
                    Text("We")
                        .font(.system(size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                        .fontDesign(.serif)
                        .shadow(radius: 4)
                    
                    Menu {
                        ForEach(filterOptions, id: \.self) { option in
                            Button {
                                selectedMode = option
                            } label: {
                                Text(option)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedMode)
                            
                            Image(systemName: "arrow.down")
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            
                Button {
                    showingCreate.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .font(.title)

            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(posts, id: \.id) { post in
                        NavigationLink(value: post) {
                            PostCell(post: post)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .navigationDestination(for: Post.self) { post in
                PostView(post: post)
            }
            .navigationTitle("We")
            .toolbar(.hidden, for: .navigationBar)
            .padding(.top, -24)
            .refreshable {
                print("DEBUG: Refresh Posts")
            }
            .sheet(isPresented: $showingCreate) {
                CreateView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    HomeView()
}
