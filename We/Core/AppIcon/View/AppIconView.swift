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
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                        .padding(.trailing, 8)
                        .accessibilityLabel(Text(iconName))
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)

                    Text(iconName)
                        .font(.headline)
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
                    viewModel.changeIcon(to: iconName == "Pillars of Trust Light" ? nil : iconName)
                }
            }
            .navigationTitle("App Icon")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .accessibilityLabel(Text("Cancel icon selection"))
                    }
                }
            }
        }
    }
}

#Preview {
    AppIconView()
}
