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
                        HStack(alignment: .top, spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("Join the conversation")
                                    .foregroundStyle(.secondary)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                
                                Text("Where your thoughts matter, not your name.")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            HStack {
                                ForEach(0..<3) { _ in
                                    Rectangle()
                                        .frame(width: 8, height: 45)
                                        .padding(.horizontal, 2)
                                        .foregroundStyle(.ultraThickMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        .overlay {
                                            RadialGradient(gradient: .init(colors: [.blue.opacity(0.8), .teal.opacity(0.4), .mint.opacity(0.2)]), center: .center, startRadius: 0, endRadius: 1000).ignoresSafeArea()
                                        }
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                                }
                            }
                            
                        }
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
