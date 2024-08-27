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
    
    @State private var position: MapCameraPosition = .camera(MapCamera(centerCoordinate: .tamucc,
                                                                       distance: 1600,
                                                                       heading: 70,
                                                                       pitch: 50))
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Button {
                    showingSchool.toggle()
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        Map(position: $position)
                            .disabled(true)
                            .mapStyle(.standard(elevation: .realistic))
                            .overlay(alignment: .bottomTrailing) {
                                Text("Browse Places Around School")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .padding(8)
                                    .background(RoundedRectangle(cornerRadius: 4).fill(.ultraThinMaterial))
                                    .padding(8)
                            }
                    }
                }
                .frame(minHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
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
        .sheet(isPresented: $showingSchool) {
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
