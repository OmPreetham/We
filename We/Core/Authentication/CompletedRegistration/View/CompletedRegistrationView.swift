//
//  CompletedRegistrationView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/20/24.
//

import SwiftUI

struct CompletedRegistrationView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 20) {
                    AppLogoView()
                    
                    Text("Registration Complete")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Thank you for registering! Your account has been successfully created.")
                        .font(.body)
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
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .navigationBarBackButtonHidden()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    CompletedRegistrationView()
}
