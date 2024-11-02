//
//  EditBoardView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/5/24.
//

import SwiftUI

struct EditBoardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var description: String
    @State private var symbolColor: String
    @State private var systemImageName: String
    @State private var showingIconPicker = false
    @State private var showErrorAlert: Bool = false
    
    init(title: Binding<String>, description: Binding<String>, symbolColor: Binding<String>, systemImageName: Binding<String>) {
        _title = State(initialValue: title.wrappedValue)
        _description = State(initialValue: description.wrappedValue)
        _symbolColor = State(initialValue: symbolColor.wrappedValue)
        _systemImageName = State(initialValue: systemImageName.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Board Icon and Color Section
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: symbolColor).gradient.materialActiveAppearance(.automatic))
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Image(systemName: systemImageName)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                    }
                    .padding()
                    .onTapGesture {
                        showingIconPicker = true
                    }
                    
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                        .padding([.trailing, .bottom], 12)
                        .onTapGesture {
                            showingIconPicker = true
                        }
                }
                .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)

                // Form for Editing Board Details
                Form {
                    Section(header: Text("Board Details")) {
                        TextField("Title", text: $title)
                            .disableAutocorrection(true)
                        
                        TextField("Description", text: $description)
                            .disableAutocorrection(true)
                    }
                }
                .navigationTitle("Edit Board")
                .navigationBarTitleDisplayMode(.inline)
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
                            saveChanges()
                        } label: {
                            Label("Save", systemImage: "checkmark.circle.fill")
                                .labelStyle(.titleOnly)
                        }
                        .disabled(title.isEmpty || description.isEmpty || symbolColor.isEmpty || systemImageName.isEmpty)
                    }
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                IconPickerView(viewTitle: "Board Icon", selectedColor: $symbolColor, selectedSymbol: $systemImageName)
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authViewModel.errorMessage ?? "An unknown error occurred.")
            }
        }
    }
    
    /// Saves the changes made to the board.
    private func saveChanges() {
        guard let board = authViewModel.selectedBoard else { return }
        
        authViewModel.updateBoard(
            boardId: board.id,
            title: title,
            description: description,
            symbolColor: symbolColor,
            systemImageName: systemImageName
        )
        
        // Observe for errors
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust delay as needed
            if authViewModel.errorMessage != nil {
                showErrorAlert = true
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    EditBoardView(
        title: .constant("Graduation"),
        description: .constant("This board is for graduation."),
        symbolColor: .constant("33C1FF"),
        systemImageName: .constant("graduationcap.fill")
    )
    .environmentObject(AuthViewModel())
}
