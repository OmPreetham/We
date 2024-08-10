//
//  Organization.swift
//  We
//
//  Created by Om Preetham Bandi on 8/9/24.
//

import Foundation

import Foundation

struct Organization: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var content: String
    var systemImageName: String
    
    static let mockOrganizations: [Organization] = [
        Organization(id: "org1", name: "Administration", content: "Discussions about administration-related topics.", systemImageName: "gear"),
        Organization(id: "org2", name: "Engineering", content: "Everything related to engineering.", systemImageName: "hammer"),
        Organization(id: "org3", name: "Sports", content: "Topics and news related to sports.", systemImageName: "sportscourt")
    ]
}
