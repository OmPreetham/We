//
//  AnimatedMeshGradientCell.swift
//  We
//
//  Created by Om Preetham Bandi on 10/19/24.
//

import SwiftUI

struct AnimatedMeshGradientCell: View {
    @State private var isAnimating = false
    
    var body: some View {
        MeshGradient(width: 3, height: 3, points: [
            [0.0, 0.0], [0.5, 0], [1.0, 0.0],
            [0.0, 0.5], [isAnimating ? 0.1 : 0.9, isAnimating ? 0.1 : 0.9], [1.0, 0.5],
            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
        ], colors: [
            .clear, .clear, .clear,
            .clear, isAnimating ? .clear : .teal, .teal,
            .mint, .mint, .teal
        ],
                     smoothsColors: true,
                     colorSpace: .perceptual
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    AnimatedMeshGradientCell()
}

