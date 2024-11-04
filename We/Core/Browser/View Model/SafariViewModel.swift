//
//  SafariViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 9/24/24.
//

import Foundation

class SafariViewModel: ObservableObject {
    @Published var urlToOpen: IdentifiableURL?
    
    func openURL(_ url: URL) {
        urlToOpen = IdentifiableURL(url: url)
    }
    
    func closeURL() {
        urlToOpen = nil
    }
}
