//
//  ChangePasswordViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/21/24.
//

import Foundation
import Combine

class ChangePasswordViewModel: ObservableObject {
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    var isFormValid: Bool {
        !currentPassword.isEmpty && !newPassword.isEmpty && newPassword == confirmNewPassword
    }
    
    func changePassword() {
        guard isFormValid else {
            alertMessage = "Please fill in all fields and ensure new passwords match."
            showAlert = true
            return
        }
        
        isLoading = true
        
        // Create the request body
        let body: [String: Any] = [
            "oldPassword": currentPassword,
            "newPassword": newPassword
        ]
        
        // Create the request
        var request = URLRequest(url: URL(string: "http://192.168.5.84:5500/api/auth/change-password")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Add authorization header (assuming you're using JWT)
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.alertMessage = "Error: \(error.localizedDescription)"
                    self?.showAlert = true
                    return
                }
                
                guard let data = data else {
                    self?.alertMessage = "No data received from server"
                    self?.showAlert = true
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let message = json["message"] as? String {
                            self?.alertMessage = message
                            self?.showAlert = true
                            if message == "Password changed successfully" {
                                // Clear the form fields on success
                                self?.currentPassword = ""
                                self?.newPassword = ""
                                self?.confirmNewPassword = ""
                            }
                        } else if let error = json["error"] as? String {
                            self?.alertMessage = "Error: \(error)"
                            self?.showAlert = true
                        }
                    }
                } catch {
                    self?.alertMessage = "Error parsing server response"
                    self?.showAlert = true
                }
            }
        }.resume()
    }
}
