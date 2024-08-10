//
//  User.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: String
    var emailId: String
    var username: String
    
    static let mockUsers = [
        User.init(id: "user1", emailId: "alice@example.com", username: "Alice"),
        User.init(id: "user2", emailId: "bob@example.com", username: "Bob"),
        User.init(id: "user3", emailId: "charlie@example.com", username: "Charlie")
    ]
}
