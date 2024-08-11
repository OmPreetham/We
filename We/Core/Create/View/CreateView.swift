//
//  CreatePostView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var caption = ""
    
    var community: Community? = .mockCommunities[0]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    CircularProfileImageView(community: .mockCommunities[0], size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(community?.name ?? "Community")
                            .fontWeight(.semibold)
                        
                        TextField("Start writing", text: $caption, axis: .vertical)
                    }
                    .font(.subheadline)
                    
                    Spacer()
                    
                    if !caption .isEmpty {
                        Button {
                            caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .tint(.secondary)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post") {
                        dismiss()
                    }
                    .opacity(caption.isEmpty ? 0.5 : 1)
                    .disabled(caption.isEmpty)
                    .font(.subheadline)
                    .foregroundStyle(.teal)
                }
            }
        }
    }
}

#Preview {
    CreateView()
}

