//
//  AboutViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/9/24.
//

import SwiftUI
import Combine

class AboutViewModel: ObservableObject {
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
