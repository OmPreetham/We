//
//  CommunityView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/9/24.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ContentUnavailableView("No Communities", systemImage: "person.2.slash.fill", description: Text("There are no communities available."))
            }
            .navigationTitle("Communities")
        }
    }
}

#Preview {
    CommunityView()
}
