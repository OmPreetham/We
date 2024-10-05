//
//  LogoCell.swift
//  We
//
//  Created by Om Preetham Bandi on 10/03/24.
//

import SwiftUI

struct LogoCell: View {
    var body: some View {
        HStack {
            ForEach(0..<3) { _ in
                Rectangle()
                    .frame(width: 6, height: 45)
                    .padding(.horizontal, 2)
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .overlay {
                        Color.primary
                    }
                    .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
            }
        }
    }
}

#Preview {
    LogoCell()
}
