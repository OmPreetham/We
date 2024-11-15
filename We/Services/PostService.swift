//
//  PostService.swift
//  We
//
//  Created by Om Preetham Bandi on 11/9/24.
//

import Foundation

class PostService: BaseService {
    static let shared = PostService()
    private override init() {}
    
    // MARK: - Fetch Following Posts
    
    /// Fetches posts from the boards the user is following.
    func fetchFollowingPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/following") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
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
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Parse the Post array from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(customISO8601Formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let posts = try decoder.decode([Post].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(posts))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Bookmark Posts
    
    /// Fetches posts bookmarked by the user.
    func fetchBookmarkPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/bookmarks") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
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
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Parse the Post array from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(customISO8601Formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let posts = try decoder.decode([Post].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(posts))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Create Post
    
    /// Creates a new post.
    func createPost(username: String, title: String, content: String, boardId: String, completion: @escaping (Result<PostCreationResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/create") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
            return
        }
        
        // Prepare the request body
        let body: [String: Any] = [
            "username": username,
            "title": title,
            "content": content,
            "boardId": boardId
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
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Parse the PostCreationResponse object from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(PostCreationResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(response))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    struct PostCreationResponse: Codable {
        let success: String
    }
    
    // MARK: - Toggle Bookmark Post

    /// Toggles bookmarking or unbookmarking a post with the given postId.
    func toggleBookmarkPost(postId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/\(postId)/bookmark") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
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
                completion(.failure(ServiceError.invalidResponse))
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
                            completion(.failure(ServiceError.invalidData))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(ServiceError.noData))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Post by ID
    
    /// Fetches a specific post by its ID.
    func fetchPostById(postId: String, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/\(postId)") else {
            completion(.failure(ServiceError.invalidURL))
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
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Parse the Post object from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(customISO8601Formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let post = try decoder.decode(Post.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(post))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Check if Post is Bookmarked
    
    /// Checks if a post is bookmarked by the authenticated user.
    func isPostBookmarked(postId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/\(postId)/isBookmarked") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Include the access token in the Authorization header
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
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode([String: Bool].self, from: data)
                        if let isBookmarked = result["isBookmarked"] {
                            completion(.success(isBookmarked))
                        } else {
                            completion(.failure(ServiceError.invalidData))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Post Replies
    
    /// Fetches replies for a specific post.
    func fetchPostReplies(postId: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/\(postId)/replies") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Include the access token in the Authorization header if required
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle networking errors
            if let error = error {
                completion(.failure(error))
                return
            }

            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ServiceError.invalidResponse))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                // Parse the Post array from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(customISO8601Formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let replies = try decoder.decode([Post].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(replies))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    func upvotePost(postId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/\(postId)/upvote") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ServiceError.invalidResponse))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                completion(.success("Post upvoted"))
            } else {
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }

    func downvotePost(postId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/\(postId)/downvote") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ServiceError.invalidResponse))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                completion(.success("Post downvoted"))
            } else {
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
    
    // MARK: - Reply to Post

    /// Sends a reply to a specific post.
    func replyToPost(postId: String, username: String, title: String, content: String, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/\(postId)/reply") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Include the access token in the Authorization header
        if let accessToken = getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(ServiceError.noAccessToken))
            return
        }

        // Prepare the request body
        let body: [String: Any] = [
            "username": username,
            "title": title,
            "content": content
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
                completion(.failure(ServiceError.invalidResponse))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                // Parse the Post object from the response
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(customISO8601Formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let post = try decoder.decode(Post.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(post))
                        }
                    } else {
                        completion(.failure(ServiceError.noData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                // Handle server-side errors
                let errorMessage = self.parseErrorMessage(data: data)
                completion(.failure(ServiceError.serverError(message: errorMessage)))
            }
        }.resume()
    }
}
