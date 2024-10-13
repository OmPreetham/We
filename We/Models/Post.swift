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
    var user: String
    var username: String
    var parentPost: String?
    var path: String
    var upvoteCount: Int
    var downvoteCount: Int
    var commentCount: Int
    var viewCount: Int
    var board: String
    var createdAt: Date
    var updatedAt: Date
}

// Sample Post data
let samplePosts: [Post] = [
    Post(
        id: "610cda503b0f5a001e86534c",
        title: "Best Study Spots on Campus?",
        content: """
        I'm looking for the best quiet places to study around the university. So far, I’ve tried the main library and the coffee shop in the student union, but they tend to get too crowded during peak hours. 
        Does anyone know of lesser-known study spots? Ideally, places with good Wi-Fi and minimal distractions.
        """,
        user: "610cd1cf3b0f5a001e86534b",
        username: "@AnonStudent",
        parentPost: nil,
        path: ",",
        upvoteCount: 1500,
        downvoteCount: 20,
        commentCount: 120,
        viewCount: 1000,
        board: "610cf9e03b0f5a001e86534d",
        createdAt: Date(),
        updatedAt: Date()
    ),
    Post(
        id: "610cda503b0f5a001e86534d",
        title: "How to Learn SwiftUI?",
        content: """
        I am struggling with understanding SwiftUI. I've gone through the tutorials, but the more complex features like custom layouts and animations are really confusing me.
        Any tips or resources that can help simplify the learning process for a beginner like me? I’m determined to learn, but the learning curve feels steep.
        """,
        user: "610cd1cf3b0f5a001e86534a",
        username: "@SwiftLearner",
        parentPost: nil,
        path: ",",
        upvoteCount: 800,
        downvoteCount: 10,
        commentCount: 45,
        viewCount: 500,
        board: "610cf9e03b0f5a001e86534e",
        createdAt: Date(),
        updatedAt: Date()
    ),
    Post(
        id: "610cda503b0f5a001e86534e",
        title: "Where can I find good free meals on campus?",
        content: "Does anyone know where I can get free or affordable meals on campus? As a broke student, I need to cut costs. Any tips?",
        user: "610cd1cf3b0f5a001e86534c",
        username: "@HungryStudent",
        parentPost: nil,
        path: ",",
        upvoteCount: 300,
        downvoteCount: 5,
        commentCount: 30,
        viewCount: 800,
        board: "610cf9e03b0f5a001e86534f",
        createdAt: Date(),
        updatedAt: Date()
    ),
    Post(
        id: "610cda503b0f5a001e86534f",
        title: "Mental Health Resources?",
        content: """
        University life has been overwhelming, and I feel like I need to speak with someone but don't know where to go. 
        Can anyone recommend good mental health resources on campus, or are there services provided for students struggling with stress and anxiety?
        """,
        user: "610cd1cf3b0f5a001e86534d",
        username: "@StressedOut",
        parentPost: nil,
        path: ",",
        upvoteCount: 600,
        downvoteCount: 15,
        commentCount: 60,
        viewCount: 1200,
        board: "610cf9e03b0f5a001e865350",
        createdAt: Date(),
        updatedAt: Date()
    ),
    Post(
        id: "610cda503b0f5a001e865350",
        title: "Study Abroad Experiences?",
        content: """
        I'm considering studying abroad next semester and wanted to hear some experiences from others who have done it. 
        How hard was it to adjust to living in a new country? Any tips on navigating the application process or choosing a good location for a semester abroad?
        """,
        user: "610cd1cf3b0f5a001e86534e",
        username: "@Explorer",
        parentPost: nil,
        path: ",",
        upvoteCount: 1000,
        downvoteCount: 25,
        commentCount: 110,
        viewCount: 1400,
        board: "610cf9e03b0f5a001e865351",
        createdAt: Date(),
        updatedAt: Date()
    ),
    Post(
        id: "610cda503b0f5a001e865351",
        title: "Group Project Nightmares",
        content: """
        Why do professors keep assigning group projects? Half the group never shows up, and I end up doing all the work! 
        Does anyone else have any group project horror stories? How do you handle uncooperative group members?
        """,
        user: "610cd1cf3b0f5a001e86534f",
        username: "@SoloWorker",
        parentPost: nil,
        path: ",",
        upvoteCount: 1200,
        downvoteCount: 30,
        commentCount: 90,
        viewCount: 1500,
        board: "610cf9e03b0f5a001e865352",
        createdAt: Date(),
        updatedAt: Date()
    ),
    Post(
        id: "610cda503b0f5a001e865352",
        title: "Internship Opportunities for Freshmen?",
        content: """
        I'm a freshman and already worried about internships. How early should I start looking for internship opportunities, and are there any programs on campus that help students find internships?
        """,
        user: "610cd1cf3b0f5a001e865350",
        username: "@FreshmanFocus",
        parentPost: nil,
        path: ",",
        upvoteCount: 900,
        downvoteCount: 12,
        commentCount: 55,
        viewCount: 1300,
        board: "610cf9e03b0f5a001e865353",
        createdAt: Date(),
        updatedAt: Date()
    )
]
