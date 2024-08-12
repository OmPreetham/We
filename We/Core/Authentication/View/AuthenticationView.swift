//
//  AuthenticationView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/11/24.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var showingLogin: Bool = false
    @State private var showingRegistration: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 90) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Group {
                                Text("Private,")
                                Text("Safe,")
                                Text("Anonymous")
                            }
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                            Text("Your Campus Discussion Platform")
                                .foregroundStyle(.secondary)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
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
                                    .shadow(radius: 2)
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 20)  {
                        Group {
                            Button {
                                showingLogin.toggle()
                            } label: {
                                Label("Login", systemImage: "chevron.compact.right")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                            }
                            
                            Button {
                                showingRegistration.toggle()
                            } label: {
                                Label("Verify & Sign Up", systemImage: "chevron.compact.up")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                            }
                        }
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.background)
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingLogin) {
            LoginView()
        }
        .sheet(isPresented: $showingRegistration) {
            RegistrationView()
        }
    }
}

#Preview {
    AuthenticationView()
}
