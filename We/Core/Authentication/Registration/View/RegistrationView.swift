//
//  RegistrationView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var showAlert = false
    @State private var navigateToComplete = false
    
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
                            VerificationCodeInput(code: $viewModel.verificationCode, codeLength: 6)
                                .padding(.bottom)
                                .focused($focusedField, equals: .verificationCode)
                            
                            Group {
                                TextField("Enter username..", text: $viewModel.username)
                                    .textInputAutocapitalization(.never)
                                    .focused($focusedField, equals: .username)

                                SecureField("Create password..", text: $viewModel.password)
                                    .focused($focusedField, equals: .password)
                            }
                            .autocorrectionDisabled()
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
                            
                            PasswordStrengthView(password: $viewModel.password)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading) {
                                Text("There is no option to recover a forgotten password.")
                                    .font(.footnote)
                                    .lineLimit(4)
                            }
                            
                            Button {
                                viewModel.completeRegistration(
                                    onSuccess: { navigateToComplete.toggle() },
                                    onFailure: { showAlert.toggle() }
                                )
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
                                .opacity(viewModel.isLoading || !viewModel.isFormValid ? 0.6 : 1)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
                            }
                            .disabled(viewModel.isLoading || !viewModel.isFormValid)
                        }
                    }
                    .navigationTitle("Register")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(isPresented: $navigateToComplete, destination: {
                        CompletedRegistrationView()
                    })
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Cancel")
                            }
                        }
                    }
                    .interactiveDismissDisabled()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registration Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred during registration"), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusedField = .verificationCode
            }
        }
    }
}

#Preview {
    RegistrationView()
}
