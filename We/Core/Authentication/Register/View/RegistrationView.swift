//
//  RegistrationView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct RegistrationView: View {
    @FocusState private var focusedField: FocusField?
    
    enum FocusField {
        case verificationCode, username, password
    }
    
    @State private var isAccountCreated = false
    @State private var isLoading: Bool = false
    
    @State private var verificationCode: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
        
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        AuthenticationHeaderCell()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        VStack(spacing: 20)  {
                            CodeInputCell(code: $verificationCode, codeLength: 6)
                                .padding(.bottom)
                                .focused($focusedField, equals: .verificationCode)
                            
                            Group {
                                TextField("Enter username..", text: $username)
                                    .textInputAutocapitalization(.never)
                                    .focused($focusedField, equals: .username)

                                SecureField("Create password..", text: $password)
                                    .focused($focusedField, equals: .password)
                            }
                            .autocorrectionDisabled()
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)

                            PasswordStrengthView(password: $password)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading) {
                                Text("There is no option to recover a forgotten password.")
                                    .font(.footnote)
                                    .lineLimit(4)
                            }
                            
                            Button {
                                isAccountCreated.toggle()
                            } label: {
                                Group {
                                    if isLoading {
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
                                .opacity(isLoading ? 0.6 : 1)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                            }
                            .disabled(isLoading)
                        }
                    }
                    .navigationTitle("Register")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(isPresented: $isAccountCreated, destination: {
                        AccountCreatedView()
                    })
                    .padding()
                    .interactiveDismissDisabled()
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
    RegistrationView()
}
