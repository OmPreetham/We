//
//  SchoolMapView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/26/24.
//

import MapKit
import SwiftUI

enum LocationCategory: String, CaseIterable {
    case mainBuilding = "Main Building"
    case subBuilding = "Sub Building"
    case other = "Other"
}

struct Location {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let category: LocationCategory
}

private let locations = [
    Location(name: "Texas A&M University -- Corpus Christi", coordinate: .tamucc, category: .mainBuilding),
]

struct SchoolMapView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var position: MapCameraPosition = .automatic
    @State private var showingLocations: Bool = true
    
    private let locations = [
        Location(name: "Texas A&M University -- Corpus Christi", coordinate: .tamucc, category: .mainBuilding),
    ]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack {
                Map(position: $position) {
                    ForEach(locations, id: \.name) { location in
                        Annotation(location.name, coordinate: location.coordinate, anchor: .bottom) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(.purple)
                                .font(.title2)
                        }
                    }
                }
                .ignoresSafeArea(.keyboard)
                .onAppear {
                    position = .camera(MapCamera(centerCoordinate: .tamucc, distance: 5000, heading: 0, pitch: 50))
                }
                .mapStyle(.standard(elevation: .realistic))
                .sheet(isPresented: $showingLocations) {
                    LocationSearchView(position: $position, locations: locations)
                        .interactiveDismissDisabled()
                        .presentationDetents([.fraction(0.1), .medium, .large])
                        .presentationDragIndicator(.hidden)
                        .presentationBackgroundInteraction(.enabled)
                }
            }
            
            Button {
                dismiss()
            } label: {
                Label("Cancel", systemImage: "xmark.circle.fill")
                    .labelStyle(.iconOnly)
                    .font(.title)
                    .foregroundStyle(.ultraThickMaterial)
                    .padding()
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
            }
            .offset(y: 20)
        }
    }
}

struct LocationSearchView: View {
    @Binding var position: MapCameraPosition
    @State private var searchText: String = ""
    let locations: [Location]
    
    private var filteredLocations: [LocationCategory: [Location]] {
        Dictionary(grouping: locations.filter {
            searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
        }) { $0.category }
    }
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)
                .padding()
            
            List {
                ForEach(LocationCategory.allCases, id: \.self) { category in
                    if let locations = filteredLocations[category] {
                        Section(header: Text(category.rawValue)) {
                            ForEach(locations, id: \.name) { location in
                                Button {
                                    withAnimation {
                                        position = .camera(MapCamera(centerCoordinate: location.coordinate, distance: 5000, heading: 0, pitch: 50))
                                    }
                                } label: {
                                    Text(location.name)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.inset)
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("Search school places", text: $searchText)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(.quinary)
                .clipShape(.buttonBorder)
            
            if !searchText.isEmpty {
                Button(role: .cancel) {
                    searchText = ""
                } label: {
                    Label("Cancel", systemImage: "xmark.circle.fill")
                        .labelStyle(.titleOnly)
                }
            }
        }
    }
}

#Preview {
    SchoolMapView()
}
