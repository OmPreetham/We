//
//  SidebarItemView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/19/24.
//

import SwiftUI

struct SidebarItemView: View {
    var title: String
    var description: String
    var imageName: String
    var gradientColor: Color
    
    @State var isAccount: Bool = false

    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(gradientColor.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: isAccount ? 30 : 8))
                
                Image(systemName: imageName)
                    .foregroundStyle(.background)
            }
            .frame(width: isAccount ? 60 : 50, height: isAccount ? 60 : 50)
            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
            .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
}

#Preview {
    SidebarItemView(
        title: "Account",
        description: "Your personal account settings",
        imageName: "person.crop.circle",
        gradientColor: .blue,
        isAccount: true // Test with isAccount as true
    )
}
