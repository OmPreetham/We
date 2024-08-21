//
//  RegistrationViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var verificationCode: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var isFormValid: Bool {
        !username.isEmpty && password.count >= 6 && verificationCode.count == 6
    }
    
    func completeRegistration(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "http://192.168.4.126:5500/api/auth/signup") else {
            errorMessage = "Invalid URL"
            isLoading = false
            onFailure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "username": username,
            "password": password,
            "code": verificationCode
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
                    return
                }
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let success = jsonResult["success"] as? Bool, success {
                            onSuccess()
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
}
