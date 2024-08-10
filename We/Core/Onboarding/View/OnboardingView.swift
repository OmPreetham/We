//
//  OnboardingView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingShowing: Bool
    
    var body: some View {
        VStack {
            TabView {
                ForEach(onboardingData) { info in
                    VStack {
                        Image(systemName: info.systemName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                            .shadow(radius: 10)
                            .foregroundStyle(colorForSystemImage(systemName: info.systemName))

                        Text(info.label)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                            .shadow(radius: 10)
                        
                        if let content = info.content {
                            Text(content)
                                .font(.subheadline)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
            
            Button(role: .cancel) {
                isOnboardingShowing.toggle()
            } label: {
                Text("Continue")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(.background)
                    .background(.orange)
                    .tint(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(30)
        }
        .interactiveDismissDisabled()
        .tabViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .label
            UIPageControl.appearance().pageIndicatorTintColor = .secondaryLabel
        }
    }
}

#Preview {
    OnboardingView(isOnboardingShowing: .constant(true))
}

