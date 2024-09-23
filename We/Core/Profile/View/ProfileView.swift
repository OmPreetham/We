//
//  ProfileView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        NavigationStack {
            List {
                ProfileSectionView(title: "Account", items: accountItems)
                ProfileSectionView(title: "Customize", items: customizeItems)
                ProfileSectionView(title: "Extensions", items: extensionItems)
                ProfileSectionView(title: "Support", items: supportItems)
                ProfileSectionView(title: "More", items: moreItems)
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    SignOutButton(action: {
                        authenticationViewModel.logout()
                        dismiss()
                    })
                }
            }
        }
    }
    
    // MARK: - Profile Items
    
    private var accountItems: [ProfileItem] {
        [
            ProfileItem(title: "Username", icon: "theatermask.and.paintbrush", destination: AnyView(Text("Update Username"))),
            ProfileItem(title: "Password", icon: "key.viewfinder", destination: AnyView(ChangePasswordView()))
        ]
    }
    
    private var customizeItems: [ProfileItem] {
        [
            ProfileItem(title: "App Icon", icon: "app.badge", destination: AnyView(AppIconView())),
            ProfileItem(title: "Theme", icon: "paintbrush", destination: AnyView(Text("Theme Settings")))
        ]
    }
    
    private var extensionItems: [ProfileItem] {
        [
            ProfileItem(title: "Live Activities", icon: "widget.small", destination: AnyView(Text("Live Activities Settings"))),
            ProfileItem(title: "Lock Screen Widgets", icon: "lock.rectangle.stack", destination: AnyView(Text("Lock Screen Widgets"))),
            ProfileItem(title: "Home Screen Widgets", icon: "widget.large.badge.plus", destination: AnyView(Text("Home Screen Widgets")))
        ]
    }
    
    private var supportItems: [ProfileItem] {
        [
            ProfileItem(title: "FAQs", icon: "questionmark.circle", destination: AnyView(Text("FAQs"))),
            ProfileItem(title: "Send Feedback", icon: "paperplane", destination: AnyView(Text("Send Feedback"))),
            ProfileItem(title: "What's New", icon: "star", destination: AnyView(Text("What's New")))
        ]
    }
    
    private var moreItems: [ProfileItem] {
        [
            ProfileItem(title: "About", icon: "info.circle", destination: AnyView(Text("About")))
        ]
    }
}

// MARK: - Supporting Views

struct ProfileItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: AnyView
}

struct ProfileSectionView: View {
    let title: String
    let items: [ProfileItem]
    
    var body: some View {
        Section(header: Text(title)) {
            ForEach(items) { item in
                NavigationLink(destination: item.destination) {
                    Label(item.title, systemImage: item.icon)
                        .padding(.vertical, 6)
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

// MARK: - Preview

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel())
}
