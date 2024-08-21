//
//  LoginViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var isFormValid: Bool {
        email.hasSuffix("@islander.tamucc.edu") && !password.isEmpty
    }
    
    func login(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "http://192.168.4.126:5500/api/auth/login") else {
            errorMessage = "Invalid URL"
            isLoading = false
            onFailure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "email": email.lowercased(),
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    onFailure()
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received from the server"
                    onFailure()
                    return
                }
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let message = jsonResult["message"] as? String, message == "Login successful" {
                            if let token = jsonResult["token"] as? String {
                                self?.saveToken(token)
                                onSuccess()
                            } else {
                                self?.errorMessage = "Login successful, but no token received"
                            }
                        } else if let message = jsonResult["message"] as? String {
                            self?.errorMessage = message
                            onFailure()
                        } else {
                            self?.errorMessage = "Unexpected server response"
                            onFailure()
                        }
                    }
                } catch {
                    self?.errorMessage = "Error parsing server response: \(error.localizedDescription)"
                    onFailure()
                }
            }
        }.resume()
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
}
