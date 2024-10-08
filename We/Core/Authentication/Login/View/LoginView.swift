//
//  LoginView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = LoginViewModel()
    @State private var showAlert = false
    let loginSuccess: () -> Void
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 10) {
                        AuthenticationHeaderCell()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        VStack(spacing: 20)  {
                            Group {
                                TextField("Enter university email..", text: $viewModel.email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                
                                TextField("Enter username..", text: $viewModel.username)
                                    .textInputAutocapitalization(.never)
                                
                                SecureField("Enter password..", text: $viewModel.password)
                            }
                            .autocorrectionDisabled()
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            .disabled(viewModel.isLoading)
                            
                            Button {
                                viewModel.login(onSuccess: loginSuccess, onFailure: {
                                    showAlert.toggle()
                                })
                            } label: {
                                Group {
                                    if viewModel.isLoading {
                                        ProgressView()
                                    } else {
                                        Label("Login", systemImage: "chevron.compact.right")
                                    }
                                }
                                .font(.body)
                                .foregroundStyle(.background)
                                .padding()
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .background(.primary)
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
                                .opacity(viewModel.isLoading || !viewModel.isFormValid ? 0.6 : 1)
                            }
                            .disabled(viewModel.isLoading || !viewModel.isFormValid)
                        }
                    }
                    .navigationTitle("Login")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            Button {
                                dismiss()
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
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    LoginView(loginSuccess: {})
}
