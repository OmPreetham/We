//
//  CreatePostView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/5/24.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var selectedBoard: Board? = nil
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var username: String = "@AnonUser"
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSubmitting: Bool = false
    
    // For the sake of this example, we'll use sampleBoards.
    // In a real application, you'd fetch this data from your backend.
    let boards: [Board] = sampleBoards
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Username")) {
                    TextField("Enter your username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Select Board")) {
                    Picker("Board", selection: $selectedBoard) {
                        Text("Select a board").tag(Board?.none)
                        ForEach(boards, id: \.self) { board in
                            HStack {
                                Image(systemName: board.systemImageName)
                                    .foregroundColor(Color(hex: board.symbolColor))
                                Text(board.title)
                            }
                            .tag(Board?.some(board))
                        }
                    }
                }
                
                Section(header: Text("Title")) {
                    TextField("Enter post title", text: $title)
                }
                
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("New Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark.circle.fill")
                            .labelStyle(.titleOnly)
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                            } else {
                                Text("Post")
                                    .bold()
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    CreatePostView()
}
