//
//  Post.swift
//  We
//
//  Created by Om Preetham Bandi on 8/8/24.
//

import Foundation

struct Post: Identifiable, Codable, Hashable {
    var id: String // Unique identifier for the post
    var content: String // Content of the post
    var timestamp: Date // Date and time when the post was created
    var upvotes: Int // Number of upvotes
    var downvotes: Int // Number of downvotes
    
    var organisationID: String // Single topic tag like "administration"
    var userID: String // ID of the user who created the post
    var parentPostID: String? // Optional ID of the parent post for threading
    
    static let mockPosts = [
        Post(
            id: "1",
            content: "What do you think about the new policy?",
            timestamp: Date(),
            upvotes: 10,
            downvotes: 2,
            organisationID: "org1",
            userID: "user1",
            parentPostID: nil
        ),
        Post(
            id: "2",
            content: "Looking for project collaborators in the Engineering department. Looking for project collaborators in the Engineering department.Looking for project collaborators in the Engineering department.Looking for project collaborators in the Engineering department.",
            timestamp: Date().addingTimeInterval(-86400),
            upvotes: 20,
            downvotes: 1,
            organisationID: "org2",
            userID: "user2",
            parentPostID: "1"
        ),
        Post(
            id: "3",
            content: "Join the basketball team tryouts this weekend!",
            timestamp: Date().addingTimeInterval(-172800),
            upvotes: 15,
            downvotes: 0,
            organisationID: "org3",
            userID: "user3",
            parentPostID: "1"
        ),
        Post(
            id: "4",
            content: "Re: Looking for project collaborators in the Engineering department.",
            timestamp: Date().addingTimeInterval(-3600),
            upvotes: 5,
            downvotes: 0,
            organisationID: "org2",
            userID: "user1",
            parentPostID: "1" // Replace with actual UUID of parent post
        )
    ]
}
