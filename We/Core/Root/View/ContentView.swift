//
//  ContentView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    
    @AppStorage("onboarding") private var showingOnboarding: Bool = true
    @State private var showingLogin: Bool = false

    var body: some View {
        ZStack {
            if authenticationViewModel.isLoggedIn {
                TabBar()
                    .environmentObject(authenticationViewModel)
                    .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
            } else {
                AuthenticationView()
                    .environmentObject(authenticationViewModel)
                    .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
            }
        }
        .animation(.smooth, value: authenticationViewModel.isLoggedIn)
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView(isShowingOnboarding: $showingOnboarding)
        }
    }
}

#Preview {
    ContentView()
}
