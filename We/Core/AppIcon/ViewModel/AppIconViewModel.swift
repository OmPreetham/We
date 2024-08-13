//
//  AppIconViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/13/24.
//

import SwiftUI

class AppIconViewModel: ObservableObject {
    @Published var currentIcon: String?
    @Published var customAppIcons: [String] = ["Pillars of Trust Light", "Pillars of Trust Dark"]
    
    init() {
        self.currentIcon = UIApplication.shared.alternateIconName
    }
    
    func changeIcon(to iconName: String?) {
        UIApplication.shared.setAlternateIconName(iconName) { [weak self] error in
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
