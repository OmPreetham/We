//
//  AppLogoView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/13/24.
//

import SwiftUI

struct AppLogoView: View {
    var body: some View {
        HStack {
            ForEach(0..<3) { _ in
                Rectangle()
                    .frame(width: 6, height: 45)
                    .padding(.horizontal, 2)
                    .foregroundStyle(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .overlay {
                        Color.primary.ignoresSafeArea()
                    }
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
            }
        }
    }
}

#Preview {
    AppLogoView()
}
