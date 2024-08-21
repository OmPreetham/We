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
                                TextField("Enter username..", text: $viewModel.username)
                                    .textInputAutocapitalization(.never)

                                SecureField("Create password..", text: $viewModel.password)
                                
                                TextField("OTP", text: $viewModel.verificationCode)
                                    .keyboardType(.numberPad)
                            }
                            .autocorrectionDisabled()
                            .padding()
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 2)
                            .disabled(viewModel.isLoading)
                            
                            VStack(alignment: .leading) {
                                Text("There is no option to recover a forgotten password.")
                                    .font(.footnote)
                                    .lineLimit(4)
                                
                                Text("One account per person – you cannot sign up again.")
                                    .font(.footnote)
                            }
                            
                            Button {
                                viewModel.completeRegistration(onSuccess: {
                                    navigateToComplete.toggle()
                                }, onFailure: { showAlert.toggle() })
                            } label: {
                                Group {
                                    if viewModel.isLoading {
                                        ProgressView()
                                    } else {
                                        Label("Register", systemImage: "chevron.compact.up")
                                    }
                                }
                                .font(.body)
                                .foregroundStyle(.background)
                                .padding()
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .opacity(viewModel.isLoading || !viewModel.isFormValid ? 0.6 : 1)
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
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
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    RegistrationView()
}
