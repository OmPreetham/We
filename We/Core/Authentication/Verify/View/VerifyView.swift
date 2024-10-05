//
//  VerifyView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct VerifyView: View {
    @Environment(\.dismiss) var dismiss
        
    @State private var isLoading: Bool = false
    @State private var isCodeSent: Bool = false
    
    @State private var emailAddress: String = ""

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 10) {
                        AuthenticationHeaderCell()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        VStack(spacing: 20)  {
                            Group {
                                TextField("Enter university email..", text: $emailAddress)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)

                            VStack(alignment: .leading) {
                                Text("A verification code will be sent to your university email.")
                                    .font(.footnote)
                            }
                                                        
                            Button {
                                isCodeSent.toggle()
                            } label: {
                                if isLoading {
                                    ProgressView()
                                } else {
                                    Label("Send Code", systemImage: "chevron.compact.up")
                                        .font(.body)
                                        .foregroundStyle(.background)
                                        .padding()
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .background(.primary)
                                        .opacity(emailAddress.isEmpty || isLoading ? 0.6 : 1)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
                                }
                            }
                            .disabled(emailAddress.isEmpty || isLoading)
                        }
                    }
                    .navigationTitle("Verify")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(isPresented: $isCodeSent, destination: {
                        RegistrationView()
                    })
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                            }
                        }
                    }
                    .interactiveDismissDisabled()
                }
            }
        }
    }
}

#Preview {
    VerifyView()
}
