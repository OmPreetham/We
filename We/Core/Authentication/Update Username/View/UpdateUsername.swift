//
//  UpdateUsername.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct UpdateUsernameView: View {
    @State private var newUsername = ""
    @State private var isUsernameUpdated = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Username")) {
                    TextField("Enter new username", text: $newUsername)
                }
                
                Section {
                    Button("Update Username") {
                        updateUsername()
                    }
                    .disabled(newUsername.isEmpty)
                }
            }
            .navigationBarTitle("Update Username")
            .alert(isPresented: $isUsernameUpdated) {
                Alert(title: Text("Success"), message: Text("Your username has been updated."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func updateUsername() {
        // Implement the logic to update the username.
        // This could involve calling a backend service.
        print("Username updated to: \(newUsername)")
        isUsernameUpdated = true // Trigger the alert indicating success.
    }
}

#Preview {
    UpdateUsernameView()
}
