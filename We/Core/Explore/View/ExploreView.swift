//
//  ExploreView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ExploreView: View {
    @State private var showingProfile: Bool = false

    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                ContentUnavailableView.search(text: searchText)
            }
            .navigationTitle("Explore")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .onTapGesture {
                            showingProfile.toggle()
                        }
                }
            }
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

#Preview {
    ExploreView()
}
