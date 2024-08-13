//
//  LaunchScreenView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = LaunchScreenViewModel()
    
    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            
            AppLogoView()
                .offset(y: viewModel.offset)
                .rotationEffect(.degrees(viewModel.rotation))
                .scaleEffect(viewModel.scale)
        }
        .opacity(viewModel.screenOpacity)
        .onAppear {
            viewModel.startAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                isPresented.toggle()
            }
        }
    }
}

#Preview {
    LaunchScreenView(isPresented: .constant(true))
}
