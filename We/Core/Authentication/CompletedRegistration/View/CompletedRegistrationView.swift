//
//  CompletedRegistrationView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import SwiftUI

struct CompletedRegistrationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    AppLogoView()
                    
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    } else {
                        
                        Group {
                            Text("Account Created")
                                .font(.largeTitle)
                                .fontDesign(.serif)
                                .fontWeight(.bold)
                            
                            Text("Thank you for registering! Your account has been successfully created.")
                                .font(.subheadline)
                                .fontDesign(.monospaced)
                        }
                        .multilineTextAlignment(.center)
                        .padding()
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Login Now")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundStyle(.background)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding()
                    }
                }
                .navigationBarBackButtonHidden()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    CompletedRegistrationView()
}
