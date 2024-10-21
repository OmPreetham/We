//
//  AccountView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var searchText: String = ""
    @State private var showingAuthScreen: Bool = false
    @State private var showSignOutAlert: Bool = false
    
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
                    Button {
                            showSignOutAlert = true
                    } label: {
                        Label("Sign Out", systemImage: "power")
                    }
                    .tint(.red)
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            .sheet(isPresented: $showingAuthScreen) {
                AuthScreenView()
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Sign Out", role: .destructive) {
                    viewModel.logout() // Call the logout function
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
    
    private var profileItems: [SettingsItem] {
        [
            SettingsItem(title: "Activity", description: "View your recent activities", icon: "heart.text.square", destination: AnyView(ActivityView())),
            SettingsItem(title: "Bookmarks", description: "Access your saved bookmarks", icon: "bookmark", destination: AnyView(BookmarksView())),
            SettingsItem(title: "Following", description: "See who you are following", icon: "checkmark.rectangle.stack", destination: AnyView(BoardsListView(listTitle: "Following"))),
        ]
    }
    
    private var accountItems: [SettingsItem] {
        [
            SettingsItem(title: "Username", content: "ShinjiIkariUnit01", description: "Change your username", icon: "theatermask.and.paintbrush", destination: AnyView(UpdateUsernameView())),
            SettingsItem(title: "Password", description: "Update your password", icon: "key.viewfinder", destination: AnyView(ChangePasswordView()))
        ]
    }
    
    private var authorizedItems: [SettingsItem] {
        [
            SettingsItem(title: "My Boards", description: "View all your created boards", icon: "square.grid.2x2", destination: AnyView(BoardsListView(listTitle: "My Boards"))),
            SettingsItem(title: "Create Board", description: "Create a new board", icon: "plus.square", destination: AnyView(CreateBoardView())),
        ]
    }
    
    private var customizeItems: [SettingsItem] {
        [
            SettingsItem(title: "App Icon", description: "Change the app icon", icon: "app.badge", destination: AnyView(AppIconView())),
            SettingsItem(title: "Theme", description: "Customize the app's theme", icon: "paintbrush", destination: AnyView(Text("Theme Settings View")))
        ]
    }
    
    private var supportItems: [SettingsItem] {
        [
            SettingsItem(title: "FAQs", description: "Frequently Asked Questions", icon: "questionmark.circle", destination: AnyView(FAQView())),
            SettingsItem(title: "Send Feedback", description: "Send us your feedback", icon: "paperplane", destination: AnyView(Text("Send Feedback"))),
            SettingsItem(title: "What's New", description: "Check out the latest features", icon: "star", destination: AnyView(Text("What's New")))
        ]
    }
    
    private var moreItems: [SettingsItem] {
        [
            SettingsItem(title: "Onboarding", description: "View the onboarding process again", icon: "questionmark.circle", destination: AnyView(OnboardingView(isShowingOnboarding: .constant(true)))),
            SettingsItem(title: "About", description: "Learn more about this app", icon: "info.circle", destination: AnyView(AboutView()))
        ]
    }
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    var content: String = ""
    var description: String = ""
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
                    VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                            Image(systemName: item.icon)
                            
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                
                                
                                if !item.description.isEmpty {
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        } header: {
            Text(title)
                .font(.caption)
                .textCase(.uppercase)
        }
    }
}

#Preview {
    AccountView()
}
