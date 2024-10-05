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
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem {
                    Button {
                        showingCreatePost.toggle()
                    } label: {
                        Label("New Post", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                }
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
