//
//  EclipseProfileImageView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct EclipseProfileImageView: View {
    var community: Board?
    var size: Size
    
    init(community: Board? = nil, size: Size) {
        self.community = community
        self.size = size
    }
    
    enum Size {
        case small
        case medium
        case large
        case extraLarge
        
        var dimensions: CGFloat {
            switch self {
            case .small:
                return 35
            case .medium:
                return 40
            case .large:
                return 45
            case .extraLarge:
                return 50
            }
        }
    }
    
    var body: some View {
        Image(systemName: community?.systemImageName ?? "xmark.circle")
            .resizable()
            .scaledToFit()
            .frame(width: size.dimensions, height: size.dimensions, alignment: .center)
            .padding(2)
            .background(.quinary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
    }
}

#Preview {
    EclipseProfileImageView(size: .small)
}
