//
//  ChangePasswordView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/21/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ChangePasswordViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Current Password")) {
                    SecureField("Enter current password", text: $viewModel.currentPassword)
                }
                
                Section(header: Text("New Password")) {
                    SecureField("Enter new password", text: $viewModel.newPassword)
                    SecureField("Confirm new password", text: $viewModel.confirmNewPassword)
                }
                
                Section {
                    Button(action: {
                        viewModel.changePassword()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Change Password")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(viewModel.isLoading || !viewModel.isFormValid)
                }
            }
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Password Change"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if viewModel.alertMessage == "Password changed successfully" {
                            dismiss()
                        }
                    }
                )
            }
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ChangePasswordView()
}
