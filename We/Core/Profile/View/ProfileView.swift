//
//  ProfileView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Account")) {
                    NavigationLink(destination: ChangePasswordView()) {
                        Label("Change Password", systemImage: "lock")
                    }
                }
                
                Section(header: Text("Personalization")) {
                    NavigationLink(destination: AppIconView()) {
                        Label("Change App Icon", systemImage: "app.badge.checkmark")
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        authenticationViewModel.logout()
                        dismiss()
                    } label: {
                        Label("Sign Out", systemImage: "power")
                    }
                    .tint(.red)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
