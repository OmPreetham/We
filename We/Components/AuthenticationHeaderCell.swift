//
//  AuthenticationHeaderCell.swift
//  We
//
//  Created by Om Preetham Bandi on 8/13/24.
//

import SwiftUI

struct AuthenticationHeaderCell: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading) {
                Text("Join the conversation")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .fontDesign(.monospaced)
                    .fontWeight(.medium)
                    .textCase(.uppercase)
                    .multilineTextAlignment(.leading)
                
                Text("Where your thoughts matter, not your name.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fontDesign(.serif)
            }
            
            Spacer()
            
            AppLogoView()
        }
    }
}

#Preview {
    AuthenticationHeaderCell()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
}
