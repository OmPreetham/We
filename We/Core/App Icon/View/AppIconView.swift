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
                        HStack(spacing: 15) {
                            Image(appIcon.previewImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text(appIcon.rawValue)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: viewModel.currentAppIcon == appIcon ? "checkmark.seal.fill" : "")
                                .foregroundStyle(Color(red: 212/255, green: 175/255, blue: 55/255))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.changeIcon(to: appIcon)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("App Icons")
        }
    }
}

#Preview {
    AppIconView()
}
