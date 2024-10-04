//
//  ContentView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct ContentView: View {
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
            // Check login status
        }
    }
}

#Preview {
    ContentView()
}

