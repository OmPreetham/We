//
//  ChangePasswordView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    @State private var isPasswordChangeSuccessful = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Current Password")) {
                    SecureField("Enter current password", text: $currentPassword)
                }
                
                Section(header: Text("New Password")) {
                    SecureField("Enter new password", text: $newPassword)
                }
                
                Section(header: Text("Confirm New Password")) {
                    SecureField("Re-enter new password", text: $confirmPassword)
                }
                
                Section {
                    Button("Change Password") {
                        // Implement password change logic here
                        changePassword()
                    }
                    .disabled(newPassword.isEmpty || confirmPassword.isEmpty || currentPassword.isEmpty || newPassword != confirmPassword)
                }
            }
            .navigationBarTitle("Change Password")
            .alert(isPresented: $isPasswordChangeSuccessful) {
                Alert(title: Text("Success"), message: Text("Your password has been changed."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func changePassword() {
        // Normally you'd have some logic to change the password, possibly involving a view model or similar approach.
        print("Password would be changed here.")
        isPasswordChangeSuccessful = true
    }
}

#Preview {
    ChangePasswordView()
}
