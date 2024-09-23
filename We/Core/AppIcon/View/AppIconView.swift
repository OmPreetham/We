//
//  AppIconView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/13/24.
//

import SwiftUI

struct AppIconView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AppIconViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.customAppIcons, id: \.self) { iconName in
                HStack {
                    Image(uiImage: UIImage(named: iconName) ?? UIImage(systemName: "app")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.trailing, 8)
                        .accessibilityLabel(Text(iconName))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)

                    Text(iconName)
                        .accessibilityHint(Text("Select to set as app icon"))
                    
                    Spacer()
                    
                    if viewModel.currentIcon == iconName {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            .accessibilityLabel(Text("Current icon"))
                    }
                }
                .padding(.vertical, 8)
                .background(.primary.opacity(0.0001))
                .onTapGesture {
                    viewModel.changeIcon(to: iconName)
                }
            }
            .navigationTitle("App Icons")
        }
    }
}

#Preview {
    AppIconView()
}
