//
//  EditBoardView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/5/24.
//

import SwiftUI

struct EditBoardView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var showingIconPicker = false
    
    @Binding var title: String
    @Binding var description: String
    @Binding var symbolColor: String
    @Binding var systemImageName: String
    
    var body: some View {
        NavigationStack {
            VStack {
                // Board Icon and Color Section
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Rectangle()
                            .fill(Color.init(hex: symbolColor).gradient)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Image(systemName: systemImageName)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                    }
                    .padding()

                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                        .padding([.trailing, .bottom], 12)
                        .onTapGesture {
                            showingIconPicker = true
                        }
                }
                .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                
                // Form for Editing Board Details
                Form {
                    Section("Board Details") {
                        TextField("Title", text: $title, axis: .vertical)
                        TextField("Description", text: $description, axis: .vertical)
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
                            dismiss()
                        } label: {
                            Label("Done", systemImage: "checkmark.circle.fill")
                                .labelStyle(.titleOnly)
                        }
                        .disabled(title.isEmpty || description.isEmpty)
                    }
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                IconPickerView(viewTitle: "Board Icon", selectedColor: $symbolColor, selectedSymbol: $systemImageName)
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
}
