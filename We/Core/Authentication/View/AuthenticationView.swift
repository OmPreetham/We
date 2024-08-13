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
                    headerSection
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 20)  {
                        Group {
                            authenticationButton(title: "Login", image: "chevron.compact.right", action: $showingLogin)
                            
                            authenticationButton(title: "Verify & Sign Up", image: "chevron.compact.up", action: $showingRegistration)
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

private var headerSection: some View {
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
        
        AppLogoView()
    }
}

private func authenticationButton(title: String, image: String, action: Binding<Bool>) -> some View {
    Button {
        action.wrappedValue.toggle()
    } label: {
        Label(title, systemImage: image)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
    }
}

#Preview {
    AuthenticationView()
}
