//
//  AuthenticationView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/11/24.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @StateObject private var safariViewModel = SafariViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 45) {
                headerSection
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                authenticationButtons
                
                Spacer()
                
                termsAndPrivacySection
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
        }
        .sheet(isPresented: $viewModel.showingLogin) {
            LoginView(loginSuccess: viewModel.setLoggedIn)
        }
        .sheet(isPresented: $viewModel.showingRequestVerificationCode) {
            RequestVerificationCodeView()
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
    
    private var authenticationButtons: some View {
        VStack(spacing: 20) {
            AuthButton(title: "Login", image: "chevron.compact.right", action: viewModel.toggleLogin)
            AuthButton(title: "Verify & Sign Up", image: "chevron.compact.up", action: viewModel.toggleRequestVerificationCode)
        }
    }
    
    private var termsAndPrivacySection: some View {
        VStack(spacing: 8) {
            Text("By using this app, you agree to our")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 4) {
                TermsButton(title: "Terms of Service", url: "https://www.ompreetham.com", viewModel: safariViewModel)
                Text("and")
                    .foregroundStyle(.secondary)
                TermsButton(title: "Privacy Policy", url: "https://www.ompreetham.com", viewModel: safariViewModel)
            }
            .modifier(SafariViewControllerViewModifier(viewModel: safariViewModel))
            .font(.caption)
            
            Text("We use cookies to improve your experience.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
    }
}

struct AuthButton: View {
    let title: String
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: image)
                .padding()
                .frame(maxWidth: .infinity)
        }
        .font(.body)
        .fontWeight(.semibold)
        .foregroundStyle(.background)
        .background(.foreground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
    }
}

struct TermsButton: View {
    let title: String
    let url: String
    let viewModel: SafariViewModel
    
    var body: some View {
        Button(title) {
            viewModel.openURL(URL(string: url)!)
        }
    }
}

#Preview {
    AuthenticationView()
}
