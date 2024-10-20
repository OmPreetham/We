//
//  AppIconView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

enum AppIcon: String, CaseIterable {
    case appIcon = "Default"
    case appIcon1 = "Rozha"
    case appIcon2 = "TAMUCC"
    
    var iconValue: String? {
        if self == .appIcon {
            return nil
        } else {
            return rawValue
        }
    }
    
    var previewImage: String {
        switch self {
        case .appIcon: return "Default"
        case .appIcon1: return "Rozha"
        case .appIcon2: return "TAMUCC"
        }
    }
    
    var description: String {
        switch self {
        case .appIcon:
            return "The default app icon with the original design."
        case .appIcon1:
            return "Featuring the original teal color with 'We' in a serif font, symbolizing elegance."
        case .appIcon2:
            return "Inspired by the 'shakas up' hand sign, with the 'Three Pillars of Trust' above the hand, symbolizing unity."
        }
    }
}

struct AppIconView: View {
    @StateObject private var viewModel = AppIconViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(AppIcon.allCases, id: \.rawValue) { appIcon in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 15) {
                                Image(appIcon.previewImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(appIcon.rawValue)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Text(appIcon.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: viewModel.currentAppIcon == appIcon ? "checkmark.seal.fill" : "")
                                    .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.changeIcon(to: appIcon)
                        }
                    }
                }
            }
            .navigationTitle("App Icons")
        }
    }
}

#Preview {
    AppIconView()
}
