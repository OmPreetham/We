//
//  CircularProfileImageView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import Kingfisher
import SwiftUI

struct CircularProfileImageView: View {
    var organisation: Organization?
    var size: Size
    
    init(organisation: Organization? = nil, size: Size) {
        self.organisation = organisation
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
                return 30
            case .medium:
                return 40
            case .large:
                return 50
            case .extraLarge:
                return 60
            }
        }
    }
    
    var body: some View {
        Image(systemName: organisation?.systemImageName ?? "xmark.circle")
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
