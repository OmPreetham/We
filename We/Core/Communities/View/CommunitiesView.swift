//
//  CommunitiesView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/10/24.
//

//
//  CommunitiesView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/10/24.
//

import SwiftUI

struct CommunitiesView: View {
    @State private var showingCreateCommunities: Bool = false
    
    var communities: [Community]? = Community.mockCommunities
    
    var body: some View {
        NavigationStack {
            if let communities = communities, !communities.isEmpty {
                List {
                    ForEach(communities) { community in
                        NavigationLink(value: community) {
                            HStack(spacing: 16) {
                                Image(systemName: community.systemImageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(community.name)
                                        .fontWeight(.semibold)
                                    
                                    Text(community.content)
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(3)
                                }
                            }
                        }
                    }
                }
                .navigationDestination(for: Community.self, destination: { community in
                    CommunityView(community: community)
                })
                .navigationTitle("Communities")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingCreateCommunities.toggle()
                        } label: {
                            Label("New Community", systemImage: "plus")
                        }
                        
                    }
                }
                .sheet(isPresented: $showingCreateCommunities) {
                    CreateCommunity()
                        .presentationDetents([.medium, .large])
                }
            } else {
                ContentUnavailableView("No Communities", systemImage: "people.3.fill", description: Text("There are no communities available."))
            }
        }
    }
}

#Preview {
    CommunitiesView()
}
