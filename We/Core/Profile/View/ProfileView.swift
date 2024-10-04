//
//  ProfileView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

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
                        // Call SignOut Function
                        dismiss()
                    })
                }
            }
        }
    }
    
    // MARK: - Profile Items
    
    private var accountItems: [ProfileItem] {
        [
            ProfileItem(title: "Username", content: "OmPreetham", icon: "theatermask.and.paintbrush", destination: AnyView(UpdateUsernameView())),
            ProfileItem(title: "Password", icon: "key.viewfinder", destination: AnyView(ChangePasswordView()))
        ]
    }
    
    private var customizeItems: [ProfileItem] {
        [
            ProfileItem(title: "App Icon", icon: "app.badge", destination: AnyView(Text("Change App Icon View"))),
            ProfileItem(title: "Theme", icon: "paintbrush", destination: AnyView(Text("Theme Settings View")))
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
    var content: String = ""
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
    ProfileView()
}
