//
//  Organization.swift
//  We
//
//  Created by Om Preetham Bandi on 8/9/24.
//

import Foundation

struct Board: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var content: String
    var systemImageName: String
    var artwork: String
    
    static let mockBoards: [Board] = [
        Board(id: "org4", name: "General", content: "A space for open discussions on any topic of interest, where all ideas and questions are welcome.", systemImageName: "exclamationmark.circle", artwork: "eva-4"),
        Board(id: "org1", name: "Administration", content: "Discussions about administration-related topics.", systemImageName: "gear", artwork: "eva"),
        Board(id: "org2", name: "Engineering", content: "Everything related to engineering.", systemImageName: "hammer", artwork: "eva-2"),
        Board(id: "org3", name: "Sports", content: "Topics and news related to sports.", systemImageName: "sportscourt", artwork: "eva-3")
    ]
}
