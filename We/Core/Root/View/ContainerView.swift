//
//  ContainerView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ContainerView: View {
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    
    @State private var showingLaunchScreen: Bool = true
    
    var body: some View {
        ZStack {
            if showingLaunchScreen {
                LaunchScreenView(isPresented: $showingLaunchScreen)
            } else {
                ContentView()
                    .environmentObject(authenticationViewModel)
            }
        }
        .onAppear {
            authenticationViewModel.checkLoginStatus()
        }
        .tint(.primary)
    }
}

#Preview {
    ContainerView()
}

