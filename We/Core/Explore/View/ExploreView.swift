//
//  ExploreView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ExploreView: View {
    @State private var showingAuthentication: Bool = false
    @State private var showingAppIcon: Bool = false
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                if #available(iOS 17.0, *) {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    Text("No Results for \(searchText)")
                }
            }
            .navigationTitle("Explore")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "person.circle.fill")
                        .onTapGesture {
                            showingAuthentication.toggle()
                        }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "square.stack.3d.up.badge.a")
                        .onTapGesture {
                            showingAppIcon.toggle()
                        }
                }
            }
        }
        .sheet(isPresented: $showingAuthentication) {
            AuthenticationView()
        }
        .sheet(isPresented: $showingAppIcon) {
            AppIconView()
        }
    }
}

#Preview {
    ExploreView()
}
