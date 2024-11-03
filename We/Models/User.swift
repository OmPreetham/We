//
//  User.swift
//  We
//
//  Created by Om Preetham Bandi on 10/20/24.
//

import Foundation

struct User: Codable, Identifiable, Equatable, Hashable {
    let id: String
    var username: String?
    let email: String?
    let role: String? // e.g., "admin", "moderator", "user"

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case email
        case role
    }
}
