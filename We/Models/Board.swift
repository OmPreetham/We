//
//  Board.swift
//  We
//
//  Created by Om Preetham Bandi on 10/13/24.
//

import Foundation

struct Board: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let symbolColor: String
    let systemImageName: String
    let userId: String // Changed from 'user: User' to 'userId: String'

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case symbolColor
        case systemImageName
        case userId = "user"
    }
}

// Sample Board data
let sampleBoards: [Board] = [
    Board(
        id: "610cf9e03b0f5a001e86534d",
        title: "Study Board",
        description: "A board dedicated to finding great study spots",
        symbolColor: "610cd1cf3b0f5a001e86534b",
        systemImageName: "#FF5733", // Orange color
        userId: "books.vertical"
    ),
    Board(
        id: "610cf9e03b0f5a001e86534e",
        title: "Learning",
        description: "A board for learning and sharing tips",
        symbolColor: "610cd1cf3b0f5a001e86534a",
        systemImageName: "#33FF57", // Green color
        userId: "swift"
    ),
    Board(
        id: "610cf9e03b0f5a001e86534f",
        title: "Student Life",
        description: "Discuss all things related to student life",
        symbolColor: "610cd1cf3b0f5a001e86534c",
        systemImageName: "#FF33A8", // Pink color
        userId: "person.3.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865350",
        title: "Health & Wellness",
        description: "Mental health and wellness resources",
        symbolColor: "610cd1cf3b0f5a001e86534d",
        systemImageName: "#33C1FF", // Blue color
        userId: "heart.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865351",
        title: "Study Abroad",
        description: "For students interested in studying abroad",
        symbolColor: "610cd1cf3b0f5a001e86534e",
        systemImageName: "#FF6B33", // Orange color
        userId: "airplane"
    ),
    Board(
        id: "610cf9e03b0f5a001e865352",
        title: "Group Projects",
        description: "Vent or share tips about group projects",
        symbolColor: "610cd1cf3b0f5a001e86534f",
        systemImageName: "#8E44AD", // Purple color
        userId: "person.2.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865353",
        title: "Internships & Careers",
        description: "Career tips, internships, and job search discussions",
        symbolColor: "610cd1cf3b0f5a001e865350",
        systemImageName: "#2980B9", // Dark Blue color
        userId: "briefcase.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865354",
        title: "On-Campus Jobs",
        description: "Find part-time jobs on campus",
        symbolColor: "610cd1cf3b0f5a001e865350",
        systemImageName: "#27AE60", // Green color
        userId: "creditcard.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865355",
        title: "Events & Clubs",
        description: "Share info about university events and clubs",
        symbolColor: "610cd1cf3b0f5a001e865350",
        systemImageName: "#E67E22", // Orange color
        userId: "calendar"
    ),
    Board(
        id: "610cf9e03b0f5a001e865356",
        title: "Housing & Dorm Life",
        description: "Housing tips, dorm life discussions",
        symbolColor: "610cd1cf3b0f5a001e865350",
        systemImageName: "#34495E", // Dark Grey color
        userId: "house.fill"
    )
]
