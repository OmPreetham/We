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
    
    @StateObject private var viewModel: CreatePostViewModel
    @FocusState private var isContentFocused: Bool

    init(selectedBoard: Board? = nil) {
        _viewModel = StateObject(wrappedValue: CreatePostViewModel(selectedBoard: selectedBoard))
    }

    var body: some View {
        NavigationStack {
            List {
                // Board Picker
                Picker("Board:", selection: $viewModel.selectedBoard) {
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

                    TextField("Enter username", text: $viewModel.username)
                }

                // Subject Field
                HStack {
                    Text("Subject:")
                        .foregroundStyle(.secondary)

                    TextField("", text: $viewModel.subject)
                }

                // Content Field
                TextEditor(text: $viewModel.content)
                    .frame(minHeight: 200)
                    .focused($isContentFocused)
                    .listRowSeparator(.hidden, edges: .bottom)
            }
            .listStyle(.plain)
            .onAppear {
                isContentFocused = true
            }
            .navigationTitle(viewModel.subject.isEmpty ? "New Post" : viewModel.subject)
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
                        if viewModel.validateFields() {
                            viewModel.createPost {
                                dismiss()
                            }
                        }
                    } label: {
                        HStack {
                            if viewModel.isSubmitting {
                                ProgressView()
                            } else {
                                Text("Post")
                                    .bold()
                            }
                        }
                    }
                    .disabled(viewModel.subject.isEmpty || viewModel.content.isEmpty || viewModel.selectedBoard == nil)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Create Post Alert"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    CreatePostView()
        .environmentObject(AuthViewModel())
}
