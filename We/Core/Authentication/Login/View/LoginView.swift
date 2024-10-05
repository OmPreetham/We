//
//  LoginView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/04/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoading: Bool = false
    @State private var isLoggedIn: Bool = false
    
    @State private var emailAddress: String = ""
    @State private var username: String = ""
    @State private var password: String = ""

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
                                TextField("Enter university email..", text: $emailAddress)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                
                                TextField("Enter username..", text: $username)
                                    .textInputAutocapitalization(.never)
                                
                                SecureField("Enter password..", text: $password)
                            }
                            .autocorrectionDisabled()
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                            .disabled(isLoading)
                            
                            Button {
                                
                            } label: {
                                Group {
                                    if isLoading {
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
                                .opacity(isLoading ? 0.6 : 1)
                            }
                            .disabled(isLoading)
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
    }
}

#Preview {
    LoginView()
}
