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
    @State private var subject: String = ""
    @State private var content: String = ""
    @State private var username: String = "ShinjiIkari"
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSubmitting: Bool = false
    
    @FocusState private var isContentFocused: Bool
    
    let boards: [Board] = sampleBoards
    
    var body: some View {
        NavigationStack {
            List {
                Group {
//                    Picker("To:", selection: $selectedBoard) {
//                        Label("Select a board", systemImage: "filemenu.and.selection")
//                            .tag(Board?.none)
//                        
//                        ForEach(boards, id: \.self) { board in
//                            Label(board.title, systemImage: board.systemImageName)
//                                .tag(Board?.some(board))
//                        }
//                    }
//                    .pickerStyle(.menu)
//                    .listRowSeparator(.hidden, edges: .top)
//                    .foregroundStyle(.secondary)
//                    
                    HStack {
                        Text("From:")
                            .foregroundStyle(.secondary)
                        
                        TextField("Enter anonymous username", text: $username)
                    }
                    
                    HStack {
                        Text("Subject:")
                            .foregroundStyle(.secondary)
                        
                        TextField("", text: $subject)
                    }
                }
                .disableAutocorrection(true)

                TextField("", text: $content, axis: .vertical)
                    .textFieldStyle(.plain)
                    .listRowSeparator(.hidden, edges: .bottom)
                    .focused($isContentFocused)
            }
            .listStyle(.plain)
            .onAppear {
                isContentFocused = true
            }
            .navigationTitle(subject.isEmpty ? "New Post" : subject)
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
