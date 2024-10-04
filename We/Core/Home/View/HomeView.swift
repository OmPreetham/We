//
//  HomeView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct HomeView: View {
    let options = ["For You", "Following"]
    @State private var selectedOption = "For You"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Picker("Options", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                            .tag(option)
                    }
                }
                .padding(.horizontal)
                .pickerStyle(.segmented)
            }
            .navigationTitle("Today")
        }
    }
}

#Preview {
    HomeView()
}
