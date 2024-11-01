//
//  Post.swift
//  We
//
//  Created by Om Preetham Bandi on 10/13/24.
//

import Foundation

struct Post: Identifiable, Codable {
    var id: String
    var title: String
    var content: String
    var user: User
    var username: String
    var parentPost: String?
    var path: String
    var upvoteCount: Int
    var downvoteCount: Int
    var commentCount: Int
    var viewCount: Int
    var board: Board
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case content
        case user
        case username
        case parentPost
        case path
        case upvoteCount
        case downvoteCount
        case commentCount
        case viewCount
        case board
        case createdAt
        case updatedAt
    }
}

// Sample Post data with User and Board objects
let sampleUsers: [User] = [
    User(id: "610cd1cf3b0f5a001e86534b", username: "@AnonStudent", email: "anon@student.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534a", username: "@SwiftLearner", email: "swift@learner.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534c", username: "@HungryStudent", email: "hungry@student.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534d", username: "@StressedOut", email: "stressed@student.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534e", username: "@Explorer", email: "explorer@student.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e86534f", username: "@SoloWorker", email: "solo@worker.com", role: "user"),
    User(id: "610cd1cf3b0f5a001e865350", username: "@FreshmanFocus", email: "freshman@focus.com", role: "user")
]

let samplePosts: [Post] = [
    Post(
        id: "610cda503b0f5a001e86534c",
        title: "Best Study Spots on Campus?",
        content: "Looking for the best quiet places to study...",
        user: sampleUsers[0],
        username: "@AnonStudent",
        parentPost: nil,
        path: ",",
        upvoteCount: 1500,
        downvoteCount: 20,
        commentCount: 120,
        viewCount: 1000,
        board: sampleBoards[0],
        createdAt: Date(),
        updatedAt: Date()
    ),
    Post(
        id: "610cda503b0f5a001e86534c",
        title: "Best Study Spots on Campus?",
        content: "Looking for the best quiet places to study...",
        user: sampleUsers[0],
        username: "@AnonStudent",
        parentPost: nil,
        path: ",",
        upvoteCount: 1500,
        downvoteCount: 20,
        commentCount: 120,
        viewCount: 1000,
        board: sampleBoards[0],
        createdAt: Date(),
        updatedAt: Date()
    ),
    Post(
        id: "610cda503b0f5a001e86534c",
        title: "Best Study Spots on Campus?",
        content: "Looking for the best quiet places to study...",
        user: sampleUsers[0],
        username: "@AnonStudent",
        parentPost: nil,
        path: ",",
        upvoteCount: 1500,
        downvoteCount: 20,
        commentCount: 120,
        viewCount: 1000,
        board: sampleBoards[0],
        createdAt: Date(),
        updatedAt: Date()
    ),
    Post(
        id: "610cda503b0f5a001e86534c",
        title: "Best Study Spots on Campus?",
        content: "Looking for the best quiet places to study...",
        user: sampleUsers[0],
        username: "@AnonStudent",
        parentPost: nil,
        path: ",",
        upvoteCount: 1500,
        downvoteCount: 20,
        commentCount: 120,
        viewCount: 1000,
        board: sampleBoards[0],
        createdAt: Date(),
        updatedAt: Date()
    ),
    // More posts following the same structure...
]
