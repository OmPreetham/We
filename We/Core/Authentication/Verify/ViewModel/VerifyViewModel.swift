//
//  VerifyViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import Foundation

class VerifyViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var isValidEmail: Bool {
        email.hasSuffix("@islander.tamucc.edu")
    }
    
    func requestVerificationCode(onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        guard let url = URL(string: "http://192.168.4.126:5500/api/auth/verify") else {
            errorMessage = "Invalid URL"
            isLoading = false
            onFailure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email.lowercased()]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        isLoading = true
        
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
                        if let message = jsonResult["message"] as? String {
                            if message.contains("Verification code sent") {
                                onSuccess()
                            } else {
                                self?.errorMessage = message
                                onFailure()
                            }
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
