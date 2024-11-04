//
//  WeApp.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

@main
struct WeApp: App {
    @AppStorage("theme") private var theme: String = Theme.automatic.rawValue

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(selectedColorScheme)
        }
    }
    
    private var selectedColorScheme: ColorScheme? {
        switch Theme(rawValue: theme) ?? .automatic {
        case .automatic:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
