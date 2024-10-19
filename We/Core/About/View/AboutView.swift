//
//  AboutView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/8/24.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: {
                        openURL(URL(string: "https://x.com/OmPreetham")!)
                    }) {
                        HStack {
                            Text("X")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                        }
                    }
                    
                    Button(action: {
                        openURL(URL(string: "https://instagram.com/ompreetham")!)
                    }) {
                        HStack {
                            Text("Instagram")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                        }
                    }
                    
                    Button(action: {
                        openURL(URL(string: "https://ompreetham.com/we")!)
                    }) {
                        HStack {
                            Text("Website")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                        }
                    }
                } header: {
                    Text("Follow")
                        .font(.caption)
                        .textCase(.uppercase)
                }
                .padding(.vertical, 8)
                
                Section {
                    NavigationLink(destination: Text("Terms of Service Page")) {
                        Text("Terms of Service")
                    }
                    
                    NavigationLink(destination: Text("Privacy Policy Page")) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: Text("Licenses Page")) {
                        Text("Licenses")
                    }
                } header: {
                    Text("Legal")
                        .font(.caption)
                        .textCase(.uppercase)
                }
                .padding(.vertical, 8)
                
                VStack(alignment: .center) {
                    Text("Version 1.0")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("© 2024 We. All rights reserved.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
            }
            .navigationBarTitle("About We")
        }
    }
}

#Preview {
    AboutView()
}
