//
//  ContentView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingLaunchScreen: Bool = true
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            if showingLaunchScreen {
                LaunchScreenView(isPresented: $showingLaunchScreen)
            } else {
                ContainerView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            viewModel.checkLoginStatus()
        }
    }
}

#Preview {
    ContentView()
}
