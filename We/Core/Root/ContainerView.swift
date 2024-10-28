//
//  ContainerView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ContainerView: View {
    @AppStorage("onboarding") private var showingOnboarding: Bool = true
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoggedIn {
                NavigateView()
                    .environmentObject(viewModel)
            } else {
                AuthScreenView()
                    .environmentObject(viewModel)
            }
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView(isShowingOnboarding: $showingOnboarding)
        }
        .onAppear {
            viewModel.checkLoginStatus()
        }
    }
}

#Preview {
    ContainerView()
        .environmentObject(AuthViewModel())
}
