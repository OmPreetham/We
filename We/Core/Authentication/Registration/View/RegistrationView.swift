//
//  RegistrationView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct RegistrationView: View {
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
                                SecureField("Create password..", text: $password)
                            }
                            .padding()
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 2)
                            
                            VStack(alignment: .leading) {
                                Text("There is no option to recover a forgotten password.")
                                    .font(.footnote)
                                    .lineLimit(4)
                                
                                Text("One account per person – you cannot sign up again.")
                                    .font(.footnote)
                            }
                            
                            Button {
                                // Action for the button goes here
                            } label: {
                                Label("Verify", systemImage: "chevron.compact.up")
                                    .font(.body)
                                    .foregroundStyle(.background)
                                    .padding()
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.orange)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            }
                        }
                    }
                    .navigationTitle("Register")
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
    RegistrationView()
}
