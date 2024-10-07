//
//  FAQ.swift
//  We
//
//  Created by Om Preetham Bandi on 10/6/24.
//

import SwiftUI

struct FAQ: Identifiable {
    let id = UUID()
    let category: FAQCategory
    let question: String
    let answer: String
}

// Enum to define categories for sections
enum FAQCategory: String, CaseIterable, Identifiable {
    case accountCreation = "Account Creation"
    case verificationProcess = "Verification Process"
    case privacySecurity = "Privacy & Security"
    case anonymity = "Anonymity"
    case universitySpecific = "University-Specific Details"
    case appUsage = "How to Use the App"
    case postingGuidelines = "Posting Guidelines"
    case boardsNavigation = "Boards & Navigation"
    case securityViolations = "Security & Violations"
    
    var id: String { self.rawValue }
}
