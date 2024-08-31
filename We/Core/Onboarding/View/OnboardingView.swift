//
//  OnboardingView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/7/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    
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
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
                            .foregroundStyle(colorForSystemImage(systemName: info.systemName))

                        Text(info.label)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)

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
                isShowingOnboarding = false
            } label: {
                Text("Continue")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(.background)
                    .background(.orange)
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
    OnboardingView(isShowingOnboarding: .constant(true))
}

