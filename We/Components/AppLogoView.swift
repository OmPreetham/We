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
                        RadialGradient(gradient: .init(colors: [.blue.opacity(0.8), .teal.opacity(0.4), .mint.opacity(0.2)]), center: .center, startRadius: 0, endRadius: 1000).ignoresSafeArea()
                    }
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
            }
        }
    }
}

#Preview {
    AppLogoView()
}
