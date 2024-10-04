//
//  ContainerView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ContainerView: View {
    @AppStorage("onboarding") private var showingOnboarding: Bool = true
    
    @State private var showingLogin: Bool = false
    @State private var isLoggedIn: Bool = true

    var body: some View {
        ZStack {
            if isLoggedIn {
                TabBarView()
            } else {
                AuthScreenView()
            }
        }
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView(isShowingOnboarding: $showingOnboarding)
        }
    }
}

#Preview {
    ContainerView()
}
