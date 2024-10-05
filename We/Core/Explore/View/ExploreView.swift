//
//  ExploreView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText: String = ""
    
    @State private var showingSettings: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem {
                    Button {
                        showingSettings.toggle()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .searchable(text: $searchText, prompt: "Search")
        }
    }
}

#Preview {
    ExploreView()
}
