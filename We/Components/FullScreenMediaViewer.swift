//
//  FullScreenMediaViewer.swift
//  We
//
//  Created by Om Preetham Bandi on 8/10/24.
//

import SwiftUI

struct FullScreenMediaViewer: View {
    @Binding var selectedImage: Int
    let imageNames = ["eva", "eva-2", "eva-3", "eva-4"]

    var body: some View {
        ZStack {
            TabView(selection: $selectedImage) {
                ForEach(imageNames.indices, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
        .background(.black)
    }
}

#Preview {
    FullScreenMediaViewer(selectedImage: .constant(0))
}
