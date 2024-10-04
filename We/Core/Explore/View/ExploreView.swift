//
//  ExploreView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText: String = ""
    
    @State private var showingProfile: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem {
                    Button {
                        showingProfile.toggle()
                    } label: {
                        Image(systemName: "person.and.background.dotted")
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
            .searchable(text: $searchText, prompt: "Search")
        }
    }
}

#Preview {
    ExploreView()
}
