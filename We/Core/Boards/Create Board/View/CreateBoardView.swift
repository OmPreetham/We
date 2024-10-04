//
//  CreateBoardView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct CreateBoardView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var systemImageName = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $content)
            }
            .navigationTitle("Create Board")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem {
                    Button("Create") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CreateBoardView()
}
