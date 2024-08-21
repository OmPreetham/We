//
//  AuthenticationViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
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
