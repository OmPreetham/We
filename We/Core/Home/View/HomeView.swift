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
    var organisation: Organization? = Organization.mockOrganizations[0]

    var body: some View {
        NavigationStack {
            HStack {
                Group {
                    Text("We")
                        .font(.system(size: 44))
                        .fontWeight(.bold)
                        .foregroundStyle(.teal)
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
                        .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
            
                Image(systemName: "plus")
                    .font(.title)
                    .onTapGesture {
                        showingCreate.toggle()
                    }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(posts, id: \.id) { post in
                        NavigationLink(value: post) {
                            PostCell(post: post)
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        print("Hello")
                                    } label: {
                                        Label("Hello", systemImage: "plus")
                                    }
                                }
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
            .scrollIndicators(.hidden)
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
