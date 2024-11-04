//
//  WhatsNewViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/3/24.
//

import SwiftUI

let whatsNewData: [WhatsNew] = [
    WhatsNew(version: "1.0", features: [
        Feature(title: "New Design", content: "We have completely revamped the app design."),
        Feature(title: "Bug Fixes", content: "Fixed several bugs reported by users.")
    ]),
    WhatsNew(version: "1.1", features: [
        Feature(title: "Performance Improvements", content: "App is now faster and more responsive."),
        Feature(title: "Dark Mode", content: "Added support for dark mode.")
    ])
]
