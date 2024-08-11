//
//  ScrollMediaView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/10/24.
//

import SwiftUI

struct ScrollMediaView: View {
    let imageNames: [String]
    @Binding var selectedImage: Int
    @Binding var showingMediaViewer: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(
                rows: [GridItem(.flexible(minimum: 200))],
                spacing: 8
            ) {
                ForEach(imageNames.indices, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            selectedImage = index
                            showingMediaViewer.toggle()
                        }
                }
            }
            .frame(maxHeight: 150)
        }
        .scrollIndicators(.hidden)
        .sheet(isPresented: $showingMediaViewer) {
            FullScreenMediaViewer(selectedImage: $selectedImage)
        }
    }
}

#Preview {
    ScrollMediaView(imageNames: ["eva","eva-2","eva-3","eva-4"], selectedImage: .constant(3), showingMediaViewer: .constant(true))
}
