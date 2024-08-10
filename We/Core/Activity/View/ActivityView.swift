//
//  ActivityView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ContentUnavailableView("No Activity", systemImage: "bell.badge.slash", description: Text("There is no recent activity to show."))
            }
            .navigationTitle("Activity")
        }
    }
}

#Preview {
    ActivityView()
}
