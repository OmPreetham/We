//
//  RequestVerificationCodeView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import SwiftUI

struct RequestVerificationCodeView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = RequestVerificationCodeViewModel()
    @State private var showAlert = false
    @State private var navigateToRegistration = false

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
                                    .autocorrectionDisabled()
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)

                            VStack(alignment: .leading) {
                                Text("A verification code will be sent to your university email.")
                                    .font(.footnote)
                            }
                                                        
                            Button {
                                viewModel.requestVerificationCode {
                                    navigateToRegistration.toggle()
                                } onFailure: {
                                    showAlert.toggle()
                                }
                            } label: {
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    Label("Send Code", systemImage: "chevron.compact.up")
                                        .font(.body)
                                        .foregroundStyle(.background)
                                        .padding()
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .background(.primary)
                                        .opacity(viewModel.isLoading || !viewModel.isValidEmail ? 0.6 : 1)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
                                }
                            }
                            .disabled(viewModel.isLoading || !viewModel.isValidEmail)
                        }
                    }
                    .navigationTitle("Verify")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(isPresented: $navigateToRegistration, destination: {
                        RegistrationView()
                    })
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
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    RequestVerificationCodeView()
}
