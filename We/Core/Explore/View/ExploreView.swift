//
//  ExploreView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    @State private var showingAuthentication: Bool = false
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
                ToolbarItem(placement: .automatic) {
                    Label("Account", systemImage: "person.circle")
                        .onTapGesture {
                            showingAuthentication.toggle()
                        }
                }
            }
        }
        .sheet(isPresented: $showingAuthentication) {
            ProfileView()
                .environmentObject(authenticationViewModel)
        }
    }
}

#Preview {
    ExploreView()
}
