//
//  ThankYouCardRotationEffectModifier.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct ThankYouCardRotationEffectModifier: ViewModifier {
    var pitch: Double
    var roll: Double
    var hoverX: CGFloat
    var hoverY: CGFloat

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(-pitch * 5 + hoverY * 5),
                axis: (x: 1, y: 0, z: 0)
            )
            .rotation3DEffect(
                .degrees(-roll * 5 + hoverX * 5),
                axis: (x: 0, y: 1, z: 0)
            )
    }
}
