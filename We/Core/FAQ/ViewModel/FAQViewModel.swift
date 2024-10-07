//
//  FAQViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 10/6/24.
//

import SwiftUI

class FAQViewModel: ObservableObject {
    // Published variable to trigger view updates
    @Published var faqList: [FAQ] = []
    @Published var expandedSections: Set<FAQCategory> = []
    
    init() {
        loadFAQs()
    }
    
    // Function to load FAQ data (Could be from an API or database in a real-world app)
    func loadFAQs() {
        self.faqList = [
            // Sample FAQ Data
            FAQ(category: .accountCreation, question: "How do I create an account?", answer: "To create an account, use your university email ID. You will receive a verification code in your email. Enter this code during the verification process to complete account creation."),
            FAQ(category: .verificationProcess, question: "What is the verification process?", answer: "The platform sends a one-time OTP to your university email ID during registration. Once verified, your email is hashed, salted, and encrypted for security. We do not send any emails other than the OTPs."),
            FAQ(category: .privacySecurity, question: "How is my privacy ensured?", answer: "Your email ID is securely encrypted, and even if a university wants to check the platform, they cannot see if you are registered. Multiple accounts can be created using the same email ID for anonymity, but no password reset feature is available to maintain security."),
            FAQ(category: .anonymity, question: "Is my identity truly anonymous?", answer: "Yes. No one can see your email ID or real name. Even the platform administrators cannot see your original email once verified."),
            FAQ(category: .universitySpecific, question: "Can I join other university boards?", answer: "No. You can only join and post in the boards linked to your own university. However, you can post on the General board, which is visible to everyone."),
            FAQ(category: .appUsage, question: "How do I start using the app?", answer: "1. Create an account using your university email ID. 2. Verify your email with the OTP sent. 3. Choose a username. This is what will be visible on your posts. 4. Navigate to the boards using the side menu. 5. Start posting or commenting."),
            FAQ(category: .postingGuidelines, question: "What are the rules for posting?", answer: "1. Do not harass or bully others. 2. No hate speech, discrimination, or personal attacks. 3. Posts must be respectful and contribute positively."),
            FAQ(category: .boardsNavigation, question: "How do I navigate between boards?", answer: "Use the side menu to switch between the general board and your university-specific board."),
            FAQ(category: .securityViolations, question: "What happens if I violate the guidelines?", answer: "Violations such as harassment, hate speech, or malicious behavior will result in a warning, post removal, or account suspension. Repeated offenses may lead to a permanent ban.")
        ]
    }
    
    // Toggle the expanded state for a given category
    func toggleCategory(_ category: FAQCategory) {
        if expandedSections.contains(category) {
            expandedSections.remove(category)
        } else {
            expandedSections.insert(category)
        }
    }
    
    // Check if a category is expanded
    func isCategoryExpanded(_ category: FAQCategory) -> Bool {
        expandedSections.contains(category)
    }
}
