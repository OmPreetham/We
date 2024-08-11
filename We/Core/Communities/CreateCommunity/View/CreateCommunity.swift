//
//  CreateCommunity.swift
//  We
//
//  Created by Om Preetham Bandi on 8/10/24.
//

import SwiftUI

struct CreateCommunity: View {
    @Environment(\.dismiss) var dismiss

    @State private var communityName: String = ""
    @State private var communityContent: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Community Name...", text: $communityName)
                    TextField("Community Description...", text: $communityContent, axis: .vertical)
                }
                
            }
            .navigationTitle("Create Community")
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
                            .disabled(communityName.isEmpty || communityContent.isEmpty)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    CreateCommunity()
}
