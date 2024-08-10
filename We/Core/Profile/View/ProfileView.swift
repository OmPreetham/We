//
//  ProfileView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ContentUnavailableView("No Profile", systemImage: "person.slash.fill", description: Text("There is no profile information available."))
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
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
