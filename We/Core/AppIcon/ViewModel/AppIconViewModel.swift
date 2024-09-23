//
//  AppIconViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/13/24.
//

import SwiftUI

class AppIconViewModel: ObservableObject {
    @Published var currentIcon: String?
    @Published var customAppIcons: [String] = ["Light Pillars of Trust", "Dark Pillars of Trust", "Light Rubik", "Dark Rubik"]
    
    init() {
        self.currentIcon = UIApplication.shared.alternateIconName ?? "Light Pillars of Trust"
    }
    
    func changeIcon(to iconName: String) {
        let iconNameForSystem: String?
        if iconName == "Light Pillars of Trust" {
            iconNameForSystem = nil
        } else {
            iconNameForSystem = iconName
        }
        
        UIApplication.shared.setAlternateIconName(iconNameForSystem) { [weak self] error in
            if let error = error {
                print("Error changing icon: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self?.currentIcon = iconName
                }
            }
        }
    }
}
