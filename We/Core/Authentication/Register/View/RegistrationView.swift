//
//  RegistrationView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: FocusField?

    enum FocusField {
        case verificationCode, username, password
    }

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        AuthenticationHeaderCell()
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        VStack(spacing: 20)  {
                            CodeInputCell(code: $viewModel.verificationCode, codeLength: 6)
                                .padding(.bottom)
                                .focused($focusedField, equals: .verificationCode)

                            Group {
                                TextField("Enter username..", text: $viewModel.username)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focusedField, equals: .username)

                                SecureField("Create password..", text: $viewModel.password)
                                    .focused($focusedField, equals: .password)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)

                            PasswordStrengthView(password: $viewModel.password)
                                .padding(.horizontal)

                            VStack(alignment: .leading) {
                                Text("There is no option to recover a forgotten password.")
                                    .font(.footnote)
                                    .lineLimit(4)
                            }

                            Button {
                                viewModel.registerUser()
                            } label: {
                                Group {
                                    if viewModel.isLoading {
                                        ProgressView()
                                    } else {
                                        Label("Create Account", systemImage: "chevron.compact.up")
                                    }
                                }
                                .font(.body)
                                .foregroundStyle(.background)
                                .padding()
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .background(.primary)
                                .opacity(viewModel.isRegisterButtonDisabled ? 0.6 : 1)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                            }
                            .disabled(viewModel.isRegisterButtonDisabled)
                        }
                    }
                    .navigationTitle("Register")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(isPresented: $viewModel.isAccountCreated) {
                        AccountCreatedView()
                    }
                    .padding()
                    .interactiveDismissDisabled()
                    .alert(isPresented: Binding<Bool>(
                        get: { viewModel.errorMessage != nil },
                        set: { _ in viewModel.errorMessage = nil }
                    )) {
                        Alert(
                            title: Text("Error"),
                            message: Text(viewModel.errorMessage ?? "An error occurred."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusedField = .verificationCode
            }
        }
    }
}

#Preview {
    RegistrationView(viewModel: AuthViewModel())
}
