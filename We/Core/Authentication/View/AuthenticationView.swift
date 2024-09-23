//
//  AuthenticationView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/11/24.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var showingLogin: Bool = false
    @State private var showingRequestVerificationCode: Bool = false
    @State private var showingRegistration: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 45) {
                headerSection
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 20)  {
                    Group {
                        authenticationButton(title: "Login", image: "chevron.compact.right", action: $showingLogin)
                        
                        authenticationButton(title: "Verify & Sign Up", image: "chevron.compact.up", action: $showingRequestVerificationCode)
                    }
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.background)
                    .background(.foreground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
                }
                
                Spacer()
                
                termsAndPrivacySection
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
        }
        .sheet(isPresented: $showingLogin) {
            LoginView(loginSuccess: { viewModel.isLoggedIn = true })
        }
        .sheet(isPresented: $showingRequestVerificationCode) {
            RequestVerificationCodeView()
        }
    }
}

private var headerSection: some View {
    HStack(alignment: .top) {
        VStack(alignment: .leading) {
            Group {
                Text("Private")
                Text("Safe")
                Text("Anonymous")
            }
            .font(.largeTitle)
            .fontWeight(.bold)
            .fontDesign(.serif)
            
            Text("Your Campus Discussion Platform")
                .foregroundStyle(.secondary)
                .font(.subheadline)
                .fontWeight(.medium)
                .fontDesign(.monospaced)
                .multilineTextAlignment(.leading)
        }
        
        Spacer()
        
        AppLogoView()
    }
}

private var termsAndPrivacySection: some View {
    VStack(spacing: 8) {
        Text("By using this app, you agree to our")
            .font(.caption)
            .foregroundStyle(.secondary)
        
        HStack(spacing: 4) {
            Link("Terms of Service", destination: URL(string: "https://we.ompreetham.com/terms")!)
            Text("and")
                .foregroundStyle(.secondary)
            Link("Privacy Policy", destination: URL(string: "https://we.ompreetham.com/privacy")!)
        }
        .font(.caption)
        
        Text("We use cookies to improve your experience.")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .multilineTextAlignment(.center)
}

private func authenticationButton(title: String, image: String, action: Binding<Bool>) -> some View {
    Button {
        action.wrappedValue.toggle()
    } label: {
        Label(title, systemImage: image)
            .padding()
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    AuthenticationView()
}
