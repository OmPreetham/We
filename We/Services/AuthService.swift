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
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
            return
        }
        
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
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
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
                // Parse the user data
                do {
                    if let data = data {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        print("User Data: \(user)")
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
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
            return
        }
        
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
    
    // MARK: - Create Board
    
    /// Creates a new board.
    func createBoard(title: String, description: String, symbolColor: String, systemImageName: String, completion: @escaping (Result<Board, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/create") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
            return
        }
        
        // Prepare the request body
        let body: [String: String] = [
            "title": title,
            "description": description,
            "symbolColor": symbolColor,
            "systemImageName": systemImageName
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
                // Parse the Board object from the response
                do {
                    if let data = data {
                        let board = try JSONDecoder().decode(Board.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(board))
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
    
    // MARK: - Update Board
    
    /// Updates a board with the given boardId and new details.
    func updateBoard(boardId: String, title: String, description: String, symbolColor: String, systemImageName: String, completion: @escaping (Result<Board, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/\(boardId)") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
            return
        }
        
        // Prepare the request body
        let body: [String: Any] = [
            "title": title,
            "description": description,
            "symbolColor": symbolColor,
            "systemImageName": systemImageName
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
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
                // Parse the updated Board object from the response
                do {
                    if let data = data {
                        // Print the raw response data for debugging
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        }
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let updatedBoard = try decoder.decode(Board.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(updatedBoard))
                        }
                    } else {
                        completion(.failure(AuthError.noData))
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch All Boards
    
    /// Fetches all available boards.
    func fetchAllBoards(completion: @escaping (Result<[Board], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // If your backend requires authentication for this endpoint, include the access token
        // If not, you can omit this block
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
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
                // Parse the array of Board objects from the response
                do {
                    if let data = data {
                        // Print the raw response data for debugging
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        }
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let boards = try decoder.decode([Board].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(boards))
                        }
                    } else {
                        completion(.failure(AuthError.noData))
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Boards Created by User
    
    /// Fetches the boards created by the authenticated user.
    func fetchUserBoards(completion: @escaping (Result<[Board], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/myboards") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
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
                // Parse the array of Board objects from the response
                do {
                    if let data = data {
                        // Print the raw response data for debugging
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        }
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let boards = try decoder.decode([Board].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(boards))
                        }
                    } else {
                        completion(.failure(AuthError.noData))
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Toggle Follow Board

    /// Toggles following or unfollowing a board with the given boardId.
    func toggleFollowBoard(boardId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/\(boardId)/toggleFollow") else {
            completion(.failure(AuthError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
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

            // Handle server response
            if (200...299).contains(httpResponse.statusCode) {
                // Parse the message from the response
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let message = json["message"] as? String {
                            DispatchQueue.main.async {
                                completion(.success(message))
                            }
                        } else {
                            completion(.failure(AuthError.invalidData))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(AuthError.noData))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    // MARK: - Fetch Followed Boards
    
    /// Fetches the boards followed by the authenticated user.
    func fetchFollowedBoards(completion: @escaping (Result<[Board], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/following") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
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
                // Parse the array of Board objects from the response
                do {
                    if let data = data {
                        // Print the raw response data for debugging
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        }
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let boards = try decoder.decode([Board].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(boards))
                        }
                    } else {
                        completion(.failure(AuthError.noData))
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Board by ID
    
    /// Fetches a specific board by its ID.
    func fetchBoardById(boardId: String, completion: @escaping (Result<Board, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/boards/\(boardId)") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header if required
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
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
                // Parse the Board object from the response
                do {
                    if let data = data {
                        // Print the raw response data for debugging
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        }
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let board = try decoder.decode(Board.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(board))
                        }
                    } else {
                        completion(.failure(AuthError.noData))
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Following Posts
    
    /// Fetches posts from the boards the user is following.
    func fetchFollowingPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/following") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
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
                // Parse the Post array from the response
                do {
                    if let data = data {
                        // Debugging: print the response data
                        #if DEBUG
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        }
                        #endif
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(customISO8601Formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let posts = try decoder.decode([Post].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(posts))
                        }
                    } else {
                        completion(.failure(AuthError.noData))
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Bookmark Posts
    
    /// Fetches posts from the boards the user is following.
    func fetchBookmarkPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/bookmarks") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
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
                // Parse the Post array from the response
                do {
                    if let data = data {
                        // Debugging: print the response data
                        #if DEBUG
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        }
                        #endif
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(customISO8601Formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let posts = try decoder.decode([Post].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(posts))
                        }
                    } else {
                        completion(.failure(AuthError.noData))
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(AuthError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Board Posts

    /// Fetches posts from a specific board by its ID.
    func fetchBoardPosts(for boardId: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        // Construct the URL with the board ID
        guard let url = URL(string: "\(baseURL)/posts/board/\(boardId)") else {
            completion(.failure(AuthError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(AuthError.noAccessToken))
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
                // Parse the Post array from the response
                do {
                    if let data = data {
                        // Debugging: print the response data
                        #if DEBUG
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(dataString)")
                        }
                        #endif
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(customISO8601Formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let posts = try decoder.decode([Post].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(posts))
                        }
                    } else {
                        completion(.failure(AuthError.noData))
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
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
    
    func getAccessToken() -> String? {
        return getToken(key: accessTokenKey)
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
    
    // MARK: - Error Types
    
    enum AuthError: LocalizedError {
        case invalidURL
        case invalidResponse
        case invalidData
        case noData
        case serverError(message: String)
        case noAccessToken
        
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
            case .noAccessToken:
                return "No access token found. Please log in."
            }
        }
    }
}
