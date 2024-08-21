//
//  CreateCommunity.swift
//  We
//
//  Created by Om Preetham Bandi on 8/10/24.
//

import SwiftUI

struct CreateBoard: View {
    @Environment(\.dismiss) var dismiss

    @State private var boardName: String = ""
    @State private var boardContent: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Board Name...", text: $boardName)
                    TextField("Board Description...", text: $boardContent, axis: .vertical)
                }
                
            }
            .navigationTitle("Create Board")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }                
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Create")
                            .disabled(boardName.isEmpty || boardContent.isEmpty)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    CreateBoard()
}
