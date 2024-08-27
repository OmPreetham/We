//
//  ActivityView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ActivityView: View {
    @State private var showingCreate: Bool = false
    
    var body: some View {
        NavigationStack {
            LazyVStack {
                ContentUnavailableView("No Activity", systemImage: "bell.badge.slash", description: Text("There is no recent activity to show."))
            }
            .navigationTitle("Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingCreate.toggle()
                    } label: {
                        Label("New Post", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreate) {
                CreatePostView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    ActivityView()
}
