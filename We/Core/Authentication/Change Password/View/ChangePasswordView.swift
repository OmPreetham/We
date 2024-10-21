//
//  ChangePasswordView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Current Password")) {
                    SecureField("Enter current password", text: $viewModel.currentPassword)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section(header: Text("New Password")) {
                    SecureField("Enter new password", text: $viewModel.newPassword)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section(header: Text("Confirm New Password")) {
                    SecureField("Re-enter new password", text: $viewModel.confirmPassword)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                if !viewModel.isNewPasswordValid && !viewModel.newPassword.isEmpty {
                    Text("Password must be at least 8 characters, including uppercase, lowercase, number, and special character.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                Section {
                    Button(action: {
                        viewModel.changePassword()
                    }) {
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Text("Change Password")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .disabled(viewModel.isChangePasswordButtonDisabled)
                }
            }
            .navigationBarTitle("Change Password")
            .alert(isPresented: $viewModel.isPasswordChangeSuccessful) {
                Alert(title: Text("Success"), message: Text("Your password has been changed."), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An error occurred."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(AuthViewModel())
}
