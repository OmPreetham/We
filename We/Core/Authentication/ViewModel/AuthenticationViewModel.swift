//
//  AuthenticationViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var showingLogin = false
    @Published var showingRequestVerificationCode = false
    
    
    func checkLoginStatus() {
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            isLoggedIn = true
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        isLoggedIn = false
    }
    
    func setLoggedIn() {
         isLoggedIn = true
     }
     
     func toggleLogin() {
         showingLogin.toggle()
     }
     
     func toggleRequestVerificationCode() {
         showingRequestVerificationCode.toggle()
     }
}
