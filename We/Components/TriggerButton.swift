//
//  TriggerButton.swift
//  We
//
//  Created by Om Preetham Bandi on 8/13/24.
//

import SwiftUI

struct TriggerButton: View {
    var title: String
    var systemName: String?
    @Binding var trigger: Bool
    
    var body: some View {
        Button {
            trigger.toggle()
        } label: {
            HStack {
                if let name = systemName {
                    Image(systemName: name)
                }
                
                Text(title)
                    .fontWeight(.bold)
            }
            .font(.subheadline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .foregroundStyle(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 10)
        }
    }
}

#Preview {
    TriggerButton(title: "Trigger Name", systemName: "bubble", trigger: .constant(true))
}
