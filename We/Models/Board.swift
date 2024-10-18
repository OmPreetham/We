//
//  Board.swift
//  We
//
//  Created by Om Preetham Bandi on 10/13/24.
//

import Foundation
import SwiftUI

struct Board: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var description: String
    var userId: String
    var symbolColor: String
    var systemImageName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case userId = "user"
        case symbolColor
        case systemImageName
    }
}

// Sample Board data
let sampleBoards: [Board] = [
    Board(
        id: "610cf9e03b0f5a001e86534d",
        title: "Study Board",
        description: "A board dedicated to finding great study spots",
        userId: "610cd1cf3b0f5a001e86534b",
        symbolColor: "#FF5733", // Orange color
        systemImageName: "books.vertical"
    ),
    Board(
        id: "610cf9e03b0f5a001e86534e",
        title: "Learning",
        description: "A board for learning and sharing tips",
        userId: "610cd1cf3b0f5a001e86534a",
        symbolColor: "#33FF57", // Green color
        systemImageName: "swift"
    ),
    Board(
        id: "610cf9e03b0f5a001e86534f",
        title: "Student Life",
        description: "Discuss all things related to student life",
        userId: "610cd1cf3b0f5a001e86534c",
        symbolColor: "#FF33A8", // Pink color
        systemImageName: "person.3.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865350",
        title: "Health & Wellness",
        description: "Mental health and wellness resources",
        userId: "610cd1cf3b0f5a001e86534d",
        symbolColor: "#33C1FF", // Blue color
        systemImageName: "heart.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865351",
        title: "Study Abroad",
        description: "For students interested in studying abroad",
        userId: "610cd1cf3b0f5a001e86534e",
        symbolColor: "#FF6B33", // Orange color
        systemImageName: "airplane"
    ),
    Board(
        id: "610cf9e03b0f5a001e865352",
        title: "Group Projects",
        description: "Vent or share tips about group projects",
        userId: "610cd1cf3b0f5a001e86534f",
        symbolColor: "#8E44AD", // Purple color
        systemImageName: "person.2.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865353",
        title: "Internships & Careers",
        description: "Career tips, internships, and job search discussions",
        userId: "610cd1cf3b0f5a001e865350",
        symbolColor: "#2980B9", // Dark Blue color
        systemImageName: "briefcase.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865354",
        title: "On-Campus Jobs",
        description: "Find part-time jobs on campus",
        userId: "610cd1cf3b0f5a001e865350",
        symbolColor: "#27AE60", // Green color
        systemImageName: "creditcard.fill"
    ),
    Board(
        id: "610cf9e03b0f5a001e865355",
        title: "Events & Clubs",
        description: "Share info about university events and clubs",
        userId: "610cd1cf3b0f5a001e865350",
        symbolColor: "#E67E22", // Orange color
        systemImageName: "calendar"
    ),
    Board(
        id: "610cf9e03b0f5a001e865356",
        title: "Housing & Dorm Life",
        description: "Housing tips, dorm life discussions",
        userId: "610cd1cf3b0f5a001e865350",
        symbolColor: "#34495E", // Dark Grey color
        systemImageName: "house.fill"
    )
]
