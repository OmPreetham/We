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
    @State private var selectedCommunity: Community = Community.mockCommunities[0]
    
    var communities: [Community]? = Community.mockCommunities
    var user: User? = User.mockUsers[0]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    CircularProfileImageView(community: selectedCommunity, size: .medium)
                        .offset(y: 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 2) {
                            Picker("Select Community", selection: $selectedCommunity) {
                                ForEach(communities ?? [], id: \.id) { community in
                                    Text(community.name.capitalized)
                                        .tag(community)
                                }
                            }
                            .pickerStyle(.menu)
                            
                            Text(user?.username ?? "UserName")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            if !caption .isEmpty {
                                Button {
                                    caption = ""
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .tint(.red)
                                        .frame(width: 12, height: 12)
                                }
                            }
                        }
                        
                        TextField("Start writing", text: $caption, axis: .vertical)
                            .padding(.leading, 12)
                    }
                    .font(.subheadline)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .font(.subheadline)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post") {
                        dismiss()
                    }
                    .opacity(caption.isEmpty ? 0.5 : 1)
                    .disabled(caption.isEmpty)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    CreateView()
}

