//
//  LaunchScreenViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 8/13/24.
//

import SwiftUI
import Combine

class LaunchScreenViewModel: ObservableObject {
    @Published var screenOpacity: Double = 1.0
    @Published var scale: CGSize = CGSize(width: 1.0, height: 1.0)
    @Published var rotation: Double = 0
    @Published var offset: Double = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    func startAnimation() {
        withAnimation(.spring(duration: 0.5)) {
            scale = CGSize(width: 1.4, height: 1.4)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.spring(duration: 1)) {
                self.scale = CGSize(width: 1.0, height: 1.0)
                self.rotation = 90
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring(duration: 0.4)) {
                self.offset = -1000
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.4)) {
                self.screenOpacity = 0
            }
        }
    }
}
