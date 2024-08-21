//
//  ChangePasswordViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/21/24.
//

import SwiftUI
import Combine

class ChangePasswordViewModel: ObservableObject {
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var isFormValid: Bool {
        !currentPassword.isEmpty && !newPassword.isEmpty && newPassword == confirmNewPassword
    }
    
    func changePassword() {
        guard !currentPassword.isEmpty, !newPassword.isEmpty, !confirmNewPassword.isEmpty else {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }
        
        guard newPassword == confirmNewPassword else {
            alertMessage = "New passwords do not match."
            showAlert = true
            return
        }
        
        isLoading = true
        
        let url = URL(string: "http://192.168.4.126:5500/api/auth/change-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "currentPassword": currentPassword,
            "newPassword": newPassword
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.response as? HTTPURLResponse }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.alertMessage = "Failed to change password: \(error.localizedDescription)"
                    self?.showAlert = true
                }
            }, receiveValue: { [weak self] httpResponse in
                guard let self = self else { return }
                
                if let httpResponse = httpResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        self.alertMessage = "Password successfully changed."
                        self.clearFields()
                    case 401:
                        self.alertMessage = "Current password is incorrect."
                    case 400:
                        self.alertMessage = "Validation Error: Please check your inputs."
                    default:
                        self.alertMessage = "Failed to change password. Please try again."
                    }
                } else {
                    self.alertMessage = "No response from server."
                }
                
                self.showAlert = true
            })
            .store(in: &cancellables)
    }
    
    private func clearFields() {
        currentPassword = ""
        newPassword = ""
        confirmNewPassword = ""
    }
}
