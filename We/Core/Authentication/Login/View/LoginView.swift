//
//  LoginView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var login: String = ""
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
                                TextField("Enter university email..", text: $login)
                                SecureField("Enter password..", text: $password)
                            }
                            .padding()
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 2)
                            
                            Button {
                                // Action for the button goes here
                            } label: {
                                Label("Login", systemImage: "chevron.compact.right")
                                    .font(.body)
                                    .foregroundStyle(.background)
                                    .padding()
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            }
                        }
                    }
                    .navigationTitle("Login")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
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
