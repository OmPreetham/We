//
//  CreateBoardView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct CreateBoardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingIconPicker = false
    
    @State private var title = ""
    @State private var content = ""
    @State private var symbolColor: String = "33C1FF"
    @State private var systemImageName: String = "graduationcap"
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Rectangle()
                        .fill(Color.init(hex: symbolColor).gradient.materialActiveAppearance(.automatic))
                        .frame(width: 100, height: 100)
                        .clipShape(.rect(cornerRadius: 16))
                    
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
            }
            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
            .onTapGesture {
                showingIconPicker = true
            }
            
            Form {
                Section("Board Details") {
                    TextField("Title", text: $title, axis: .vertical)
                    TextField("Description", text: $content, axis: .vertical)
                }
            }
            .navigationTitle("Create Board")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        // Handle creation logic here
                        dismiss()
                    } label: {
                        Label("Create", systemImage: "plus")
                            .labelStyle(.titleOnly)
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                IconPickerView(viewTitle: "Board Icon", selectedColor: $symbolColor, selectedSymbol: $systemImageName)
            }
        }
    }
}

#Preview {
    CreateBoardView()
}
