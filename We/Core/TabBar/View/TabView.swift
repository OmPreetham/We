//
//  TabBar.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Today", systemImage: selectedTab == 0 ? "doc.text.image.fill" : "doc.text.image")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            BoardsView()
                .tabItem {
                    Label("Boards", systemImage: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                }
                .onAppear { selectedTab = 1 }
                .tag(1)            
            
            ActivityView()
                .tabItem {
                    Label("Activity", systemImage: selectedTab == 2 ? "bell.fill" : "bell")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
                .badge(10)
            
            ExploreView()
                .environmentObject(authenticationViewModel)
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
        }
    }
}

#Preview {
    TabBar()
        .environmentObject(AuthenticationViewModel())
}
