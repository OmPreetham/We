//
//  User.swift
//  We
//
//  Created by Om Preetham Bandi on 10/20/24.
//

import Foundation

struct User: Codable {
    let id: String
    var username: String
    let email: String
    // Add other fields as needed, matching the backend response

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case email
        // Add other coding keys if necessary
    }
}
