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
    @State private var username: String = "ShinjiIkari"
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSubmitting: Bool = false
    
    // For the sake of this example, we'll use sampleBoards.
    // In a real application, you'd fetch this data from your backend.
    let boards: [Board] = sampleBoards
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    Picker("To:", selection: $selectedBoard) {
                        ForEach(boards, id: \.self) { board in
                            Label(board.title, systemImage: board.systemImageName)
                                .tag(Board?.some(board))
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .listRowSeparator(.hidden, edges: .top)
                    
                    HStack {
                        Text("From:")
                        
                        TextField("AnonUser", text: $username)
                    }
                    
                    HStack {
                        Text("Subject:")
                        
                        TextField("", text: $title)
                    }
                }
                .disableAutocorrection(true)

                TextField("", text: $content, prompt: Text("Write your message here..."), axis: .vertical)
                    .textFieldStyle(.plain)
                    .listRowSeparator(.hidden, edges: .bottom)
            }
            .listStyle(.plain)
            .navigationTitle("New Text")
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
