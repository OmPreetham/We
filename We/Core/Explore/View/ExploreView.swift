//
//  ExploreView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import MapKit
import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State private var showingProfile: Bool = false
    @State private var showingSchool: Bool = false
    @State private var searchText: String = ""
    
    @State private var position: MapCameraPosition = .camera(MapCamera(centerCoordinate: .tamucc, distance: 1600, heading: 0, pitch: 50))
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Button {
                    showingSchool.toggle()
                } label: {
                    Map(position: $position)
                        .disabled(true)
                        .mapStyle(.standard(elevation: .realistic))
                        .overlay(alignment: .bottomTrailing) {
                            Text("Locate School")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial))
                                .padding(8)
                        }
                }
                .frame(minHeight: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Label("Account", systemImage: "person.circle")
                        .onTapGesture {
                            showingProfile.toggle()
                        }
                }
            }
        }
        .fullScreenCover(isPresented: $showingSchool) {
            SchoolMapView()
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView()
                .environmentObject(authenticationViewModel)
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    ExploreView()
        .environmentObject(AuthenticationViewModel())
}
