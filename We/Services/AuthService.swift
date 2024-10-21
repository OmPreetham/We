//
//  AuthService.swift
//  We
//
//  Created by Om Preetham Bandi on 10/20/24.
//

import Foundation
import Security

class AuthService {
    static let shared = AuthService()
    private init() {}
    
    // Base URL of your backend API
    private let baseURL = "http://192.168.5.92:5500/api"
    
    // Keychain keys
    let accessTokenKey = "accessToken"
    let refreshTokenKey = "refreshToken"
    
    // MARK: - Registration
    
    /// Requests a verification code to be sent to the user's email.
    func requestVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/requestverificationcode") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let body: [String: String] = ["email": email]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create the data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle networking errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(AuthError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Success
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    /// Registers a new user using the verification code, username, and password.
    func registerUser(code: String, username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/register") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let body: [String: String] = [
            "code": code,
            "username": username,
            "password": password
        ]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create the data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle networking errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(AuthError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Success
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Login
    
    /// Logs in the user with the provided credentials.
    func login(email: String, username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true // Ensure cookies are handled
        
        let body: [String: String] = [
            "email": email,
            "username": username,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(false, "Failed to encode request body")
            return
        }
        
        // Configure cookie storage
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookieAcceptPolicy = .always
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpCookieStorage = cookieStorage
        sessionConfig.httpShouldSetCookies = true
        
        let session = URLSession(configuration: sessionConfig)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Extract tokens from cookies
                if let headers = httpResponse.allHeaderFields as? [String: String],
                   let url = request.url {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                    for cookie in cookies {
                        if cookie.name == "accessToken" {
                            _ = self.saveToken(key: "accessToken", value: cookie.value)
                        }
                        if cookie.name == "refreshToken" {
                            _ = self.saveToken(key: "refreshToken", value: cookie.value)
                        }
                    }
                }
                completion(true, nil)
            } else {
                let message = self.parseErrorMessage(data: data)
                completion(false, message)
            }
        }.resume()
    }
    
    // MARK: - Logout
    
    /// Logs out the user by clearing tokens and cookies.
    func logout() {
        // Delete tokens from Keychain
        deleteToken(key: accessTokenKey)
        deleteToken(key: refreshTokenKey)
        
        // Clear cookies
        clearCookies()
    }
    
    // MARK: - Change Password
    
    /// Changes the user's password.
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/change-password") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(getAccessToken() ?? "")", forHTTPHeaderField: "Authorization")
        
        // Prepare the request body
        let body: [String: String] = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Configure the session
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpCookieStorage = HTTPCookieStorage.shared
        sessionConfig.httpShouldSetCookies = true
        let session = URLSession(configuration: sessionConfig)
        
        // Create the data task
        session.dataTask(with: request) { data, response, error in
            // Handle networking errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(AuthError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Success
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Current User

    /// Fetches the current authenticated user.
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/current-user") else {
            completion(.failure(AuthError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = true
        request.setValue("Bearer \(getAccessToken() ?? "")", forHTTPHeaderField: "Authorization")

        // Configure the session
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpCookieStorage = HTTPCookieStorage.shared
        sessionConfig.httpShouldSetCookies = true
        let session = URLSession(configuration: sessionConfig)

        session.dataTask(with: request) { data, response, error in
            // Handle networking errors
            if let error = error {
                completion(.failure(error))
                return
            }

            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(AuthError.invalidResponse))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                // Parse the user data
                do {
                    if let data = data {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(user))
                        }
                    } else {
                        completion(.failure(AuthError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Update Username

    /// Updates the user's username.
    func updateUsername(newUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/update-user") else {
            completion(.failure(AuthError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(getAccessToken() ?? "")", forHTTPHeaderField: "Authorization")

        // Prepare the request body
        let body: [String: String] = ["username": newUsername]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        // Configure the session
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpCookieStorage = HTTPCookieStorage.shared
        sessionConfig.httpShouldSetCookies = true
        let session = URLSession(configuration: sessionConfig)

        session.dataTask(with: request) { data, response, error in
            // Handle networking errors
            if let error = error {
                completion(.failure(error))
                return
            }

            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(AuthError.invalidResponse))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                // Success
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    /// Clears all cookies from the shared HTTPCookieStorage.
    private func clearCookies() {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
    
    // MARK: - Token Management
    
    /// Saves a token to the Keychain.
    func saveToken(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // Delete any existing items
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getToken(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }
    
    func deleteToken(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    /// Checks if the user is logged in by verifying the presence of the access token.
    func isLoggedIn() -> Bool {
        return getToken(key: accessTokenKey) != nil
    }
    
    // MARK: - Helper Methods
    
    /// Parses error messages from the server response.
    private func parseErrorMessage(data: Data?) -> String {
        guard let data = data else { return "Unknown error occurred." }
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorMessage = json["error"] as? String {
                return errorMessage
            } else {
                return "Unknown error occurred."
            }
        } catch {
            return "Unknown error occurred."
        }
    }
    
    func getAccessToken() -> String? {
        return getToken(key: "accessToken")
    }
    
    
    // MARK: - Error Types
    
    /// Custom error types for AuthService.
    enum AuthError: LocalizedError {
        case invalidURL
        case invalidResponse
        case invalidData
        case noData
        case serverError(message: String)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL is invalid."
            case .invalidResponse:
                return "Invalid response from the server."
            case .invalidData:
                return "Invalid data received from the server."
            case .noData:
                return "No data received from the server."
            case .serverError(let message):
                return message
            }
        }
    }
}
