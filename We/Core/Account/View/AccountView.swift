//
//  AccountView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct AccountView: View {
    @State private var searchText: String = ""

    @State private var showingAuthScreen: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                SettingsSectionView(title: "Profile", items: profileItems)
                SettingsSectionView(title: "Account", items: accountItems)
                SettingsSectionView(title: "Authorized", items: authorizedItems)
                SettingsSectionView(title: "Customize", items: customizeItems)
                SettingsSectionView(title: "Support", items: supportItems)
                SettingsSectionView(title: "More", items: moreItems)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("We Account")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SignOutButton(action: {
                        // Call SignOut Function
                        showingAuthScreen.toggle()
                    })
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            .sheet(isPresented: $showingAuthScreen) {
                AuthScreenView()
            }
        }
    }
        
    private var profileItems: [SettingsItem] {
        [
            SettingsItem(title: "Activity", icon: "heart.text.square", destination: AnyView(ActivityView())),
            SettingsItem(title: "Bookmarks", icon: "bookmark", destination: AnyView(BookmarksView())),
            SettingsItem(title: "Following", icon: "checkmark.rectangle.stack", destination: AnyView(BoardsListView(listTitle: "Following"))),
        ]
    }
    
    private var accountItems: [SettingsItem] {
        [
            SettingsItem(title: "Username", content: "ShinjiIkariUnit01", icon: "theatermask.and.paintbrush", destination: AnyView(UpdateUsernameView())),
            SettingsItem(title: "Password", icon: "key.viewfinder", destination: AnyView(ChangePasswordView()))
        ]
    }
    
    private var authorizedItems: [SettingsItem] {
        [
            SettingsItem(title: "Your Boards", icon: "square.grid.2x2", destination: AnyView(BoardsListView(listTitle: "Your Boards"))),
            SettingsItem(title: "Create Board", icon: "plus.square", destination: AnyView(CreateBoardView())),
        ]
    }
    
    private var customizeItems: [SettingsItem] {
        [
            SettingsItem(title: "App Icon", icon: "app.badge", destination: AnyView(AppIconView())),
            SettingsItem(title: "Theme", icon: "paintbrush", destination: AnyView(Text("Theme Settings View")))
        ]
    }

    private var supportItems: [SettingsItem] {
        [
            SettingsItem(title: "FAQs", icon: "questionmark.circle", destination: AnyView(FAQView())),
            SettingsItem(title: "Send Feedback", icon: "paperplane", destination: AnyView(Text("Send Feedback"))),
            SettingsItem(title: "What's New", icon: "star", destination: AnyView(Text("What's New")))
        ]
    }
    
    private var moreItems: [SettingsItem] {
        [
            SettingsItem(title: "About", icon: "info.circle", destination: AnyView(AboutView()))
        ]
    }
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    var content: String = ""
    let icon: String
    let destination: AnyView
}

struct SettingsSectionView: View {
    let title: String
    let items: [SettingsItem]
    
    var body: some View {
        Section {
            ForEach(items) { item in
                NavigationLink(destination: item.destination) {
                    HStack(spacing: 16) {
                        Image(systemName: item.icon)
                        
                        Text(item.title)
                        
                        Spacer()
                        
                        if !item.content.isEmpty {
                            Text(item.content)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        } header: {
            Text(title)
                .font(.caption)
                .textCase(.uppercase)
        }
    }
}

struct SignOutButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("Sign Out", systemImage: "power")
        }
        .tint(.red)
    }
}

#Preview {
    AccountView()
}
