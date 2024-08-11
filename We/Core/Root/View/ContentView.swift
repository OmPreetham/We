//
//  ContentView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onboarding") private var showingOnboarding: Bool = true
    @State private var showingLogin: Bool = false

    var body: some View {
        ZStack {
            if true {
                TabBar()
            }
        }
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView(isShowingOnboarding: $showingOnboarding)
        }
    }
}

#Preview {
    ContentView()
}
