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
    @State private var rotation: Double = 0
    @State private var offset: Double = 0
    
    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            
            HStack {
                ForEach(0..<3) { _ in
                    Rectangle()
                        .frame(width: 8, height: 45)
                        .padding(.horizontal, 2)
                        .foregroundStyle(.blue)
                        .offset(y: offset)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
        }
        .opacity(screenOpacity)
        .onAppear {
            withAnimation(.spring(duration: 0.5)) {
                scale = CGSize(width: 1.4, height: 1.4)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                withAnimation(.spring(duration: 1)) {
                    scale = CGSize(width: 1, height: 1)
                    rotation = 90
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4, execute: {
                withAnimation(.spring(duration: 0.2)) {
                    offset = -100
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6, execute: {
                withAnimation(.easeIn(duration: 0.2)) {
                    screenOpacity = 0
                    isPresented.toggle()
                }
            })
        }
    }
}

#Preview {
    LaunchScreenView(isPresented: .constant(true))
}
