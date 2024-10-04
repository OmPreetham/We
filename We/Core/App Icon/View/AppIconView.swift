//
//  AppIconView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

enum AppIcon: String, CaseIterable {
    case appIcon = "Default"
    case appIcon1 = "Rubik"
    
    var iconValue: String? {
        if self == .appIcon {
            return nil
        } else {
            return rawValue
        }
    }
    
    var previewImage: String {
        switch self {
        case .appIcon: "Default"
        case .appIcon1: "Rubik"
        }
    }
}

struct AppIconView: View {
    @State private var currentAppIcon = AppIcon.appIcon
    
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
                                .clipShape(.rect(cornerRadius: 10))
                            
                            Text(appIcon.rawValue)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: currentAppIcon == appIcon ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(currentAppIcon == .appIcon ? .green : Color.primary)
                            
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            currentAppIcon = appIcon
                            UIApplication.shared.setAlternateIconName(appIcon.rawValue, completionHandler: nil)
                        }
                    }
                }
            }
            .navigationTitle("App Icons")
        }
        .onAppear {
            if let alternativeAppIcon = UIApplication.shared.alternateIconName {
                let appIcon = AppIcon(rawValue: alternativeAppIcon)!
                currentAppIcon = appIcon
            } else {
                currentAppIcon = .appIcon
            }
        }
    }
}

#Preview {
    AppIconView()
}
