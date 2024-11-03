//
//  CreatePostView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/5/24.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var selectedBoard: Board? = nil
    @State private var subject: String = ""
    @State private var content: String = ""
    @State private var username: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isSubmitting: Bool = false
        
    @FocusState private var isContentFocused: Bool
    
    var body: some View {
        NavigationStack {
            List {
                // Board Picker
                Picker("Board:", selection: $selectedBoard) {
                    ForEach(authViewModel.allBoards, id: \.id) { board in
                        Label(board.title, systemImage: board.systemImageName)
                            .tag(board as Board?)
                    }
                }
                .pickerStyle(.menu)
                .listRowSeparator(.hidden, edges: .top)
                .foregroundStyle(.secondary)

                // Username Field
                HStack {
                    Text("From:")
                        .foregroundStyle(.secondary)
                    
                    TextField("Enter username", text: $username)
                }
                
                // Subject Field
                HStack {
                    Text("Subject:")
                        .foregroundStyle(.secondary)
                    
                    TextField("", text: $subject)
                }
                
                // Content Field
                TextEditor(text: $content)
                    .frame(minHeight: 200)
                    .focused($isContentFocused)
                    .listRowSeparator(.hidden, edges: .bottom)
            }
            .listStyle(.plain)
            .onAppear {
                username = authViewModel.currentUser?.username ?? ""
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
                        createPost()
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
                    .disabled(subject.isEmpty || content.isEmpty || selectedBoard == nil)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Function to create a post
    private func createPost() {
        guard let boardId = selectedBoard?.id else {
            alertMessage = "Please select a board."
            showAlert = true
            return
        }
        
        isSubmitting = true
        alertMessage = ""
        
        AuthService.shared.createPost(username: username, title: subject, content: content, boardId: boardId) { result in
            DispatchQueue.main.async {
                self.isSubmitting = false
                switch result {
                case .success(_):
                    dismiss() // Close the view upon success
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}

#Preview {
    CreatePostView()
        .environmentObject(AuthViewModel()) // Ensure your AuthViewModel is injected
}
