//
//  LaunchScreenView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @Binding var isPresented: Bool
    
    @State private var screenOpacity: Double = 1.0
    @State private var scale: CGSize = CGSize(width: 0.8, height: 0.8)
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.teal, Color.mint]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            ZStack {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(.background)
            }
            .scaleEffect(scale)
        }
        .opacity(screenOpacity)
        .onAppear {
            withAnimation(.spring(duration: 0.5)) {
                scale = CGSize(width: 1.2, height: 1.2)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                withAnimation(.spring(duration: 1)) {
                    scale = CGSize(width: 1, height: 1)
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4, execute: {
                withAnimation(.spring(duration: 0.35)) {
                    scale = CGSize(width: 108, height: 108)
                    screenOpacity = 0
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6, execute: {
                withAnimation(.easeIn(duration: 0.2)) {
                    isPresented.toggle()
                }
            })
        }
    }
}

#Preview {
    LaunchScreenView(isPresented: .constant(true))
}
