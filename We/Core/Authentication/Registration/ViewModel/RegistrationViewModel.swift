//
//  RegistrationViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var verificationCode: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var isFormValid: Bool {
        !verificationCode.isEmpty && !username.isEmpty && !password.isEmpty
    }
    
    func completeRegistration(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        guard isFormValid else {
            errorMessage = "Please fill in all fields"
            onFailure()
            return
        }
        
        isLoading = true
        
        // Create the request body
        let body: [String: Any] = [
            "code": verificationCode,
            "username": username,
            "password": password
        ]
        
        // Create the request
        var request = URLRequest(url: URL(string: "http://192.168.5.84:5500/api/auth/register")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    onFailure()
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    onFailure()
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let message = json["message"] as? String, message == "User registered successfully" {
                            onSuccess()
                        } else if let error = json["error"] as? String {
                            self?.errorMessage = error
                            onFailure()
                        } else {
                            self?.errorMessage = "Unknown error occurred"
                            onFailure()
                        }
                    }
                } catch {
                    self?.errorMessage = "Failed to parse response"
                    onFailure()
                }
            }
        }.resume()
    }
}
