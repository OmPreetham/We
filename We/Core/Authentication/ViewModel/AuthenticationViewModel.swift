//
//  AuthenticationViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var showingWebView: Bool = false
    @Published var webViewURL: URL = URL(string: "https://www.ompreetham.com")!
    
    func showWebView(for url: URL) {
        webViewURL = url
        showingWebView = true
    }
    
    func checkLoginStatus() {
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            isLoggedIn = true
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        isLoggedIn = false
    }
}
