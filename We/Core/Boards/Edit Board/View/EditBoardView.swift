//
//  EditBoardView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/5/24.
//

import SwiftUI

struct EditBoardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isSymbolPickerPresented = false
    
    @Binding var title: String
    @Binding var content: String
    @Binding var symbolColor: Color
    @Binding var systemImageName: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(symbolColor)
                    .frame(width: 100, height: 100)
                    .clipShape(.rect(cornerRadius: 16))
                
                Image(systemName: systemImageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
            }
            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
            .padding()
            .onTapGesture {
                isSymbolPickerPresented = true
            }
            
            Form {
                Section("Board Details") {
                    TextField("Title", text: $title, axis: .vertical)
                    TextField("Description", text: $content, axis: .vertical)
                }
            }
            .navigationTitle("Edit Board")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        // Handle creation logic here
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .sheet(isPresented: $isSymbolPickerPresented) {
                IconPickerView(viewTitle: "Board Icon", selectedColor: $symbolColor, selectedSymbol: $systemImageName)
            }
        }
    }
}

#Preview {
    EditBoardView(title: .constant("Graduation"), content: .constant("This board is for graduation."), symbolColor: .constant(.accentColor), systemImageName: .constant("graduationcap.fill"))
}
