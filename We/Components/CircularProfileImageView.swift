//
//  CircularProfileImageView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import Kingfisher
import SwiftUI

struct CircularProfileImageView: View {
    var community: Community?
    var size: Size
    
    init(community: Community? = nil, size: Size) {
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
            .padding(4)
            .background(.quaternary)
            .clipShape(Circle())
            .foregroundStyle(.secondary)
            .shadow(radius: 4)
    }
}

#Preview {
    CircularProfileImageView(size: .small)
}
