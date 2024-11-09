//
//  ContentView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var showingLaunchScreen: Bool = true
    
    var body: some View {
        ZStack {
            if showingLaunchScreen {
                LaunchScreenView(isPresented: $showingLaunchScreen)
            } else {
                ContainerView()
            }
        }
        .onAppear {
            authViewModel.checkLoginStatus()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
