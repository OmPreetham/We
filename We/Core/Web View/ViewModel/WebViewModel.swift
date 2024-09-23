//
//  WebViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 9/23/24.
//

import Foundation
import Combine

class WebViewModel: ObservableObject {
    @Published var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func updateURL(_ newURL: URL) {
        self.url = newURL
    }
}
