//
//  SettingsView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText: String = ""

    @State private var showingAuthScreen: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                SettingsSectionView(title: "Account", items: accountItems)
                SettingsSectionView(title: "Customize", items: customizeItems)
                SettingsSectionView(title: "Extensions", items: extensionItems)
                SettingsSectionView(title: "Support", items: supportItems)
                SettingsSectionView(title: "More", items: moreItems)
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    SignOutButton(action: {
                        // Call SignOut Function
                        showingAuthScreen.toggle()
                        dismiss()
                    })
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            .sheet(isPresented: $showingAuthScreen) {
                AuthScreenView()
            }
        }
    }
    
    // MARK: - Settings Items
    
    private var accountItems: [SettingsItem] {
        [
            SettingsItem(title: "Username", content: "OmPreetham", icon: "theatermask.and.paintbrush", destination: AnyView(UpdateUsernameView())),
            SettingsItem(title: "Password", icon: "key.viewfinder", destination: AnyView(ChangePasswordView()))
        ]
    }
    
    private var customizeItems: [SettingsItem] {
        [
            SettingsItem(title: "App Icon", icon: "app.badge", destination: AnyView(AppIconView())),
            SettingsItem(title: "Theme", icon: "paintbrush", destination: AnyView(Text("Theme Settings View")))
        ]
    }
    
    private var extensionItems: [SettingsItem] {
        [
            SettingsItem(title: "Live Activities", icon: "widget.small", destination: AnyView(Text("Live Activities Settings"))),
            SettingsItem(title: "Lock Screen Widgets", icon: "lock.rectangle.stack", destination: AnyView(Text("Lock Screen Widgets"))),
            SettingsItem(title: "Home Screen Widgets", icon: "widget.large.badge.plus", destination: AnyView(Text("Home Screen Widgets")))
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
            SettingsItem(title: "About", icon: "info.circle", destination: AnyView(Text("About")))
        ]
    }
}

// MARK: - Supporting Views

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
        Section(header: Text(title)) {
            ForEach(items) { item in
                NavigationLink(destination: item.destination) {
                    HStack {
                        Image(systemName: item.icon)
                            .frame(width: 40, height: 40)
                        
                        Text(item.title)
                        
                        Spacer()
                        
                        if !item.content.isEmpty {
                            Text("@" + item.content)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
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
    SettingsView()
}
