//
//  BoardDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct BoardDetailView: View {
    @State private var isShowingEditSheet = false
    @Environment(\.dismiss) var dismiss

    let boardItem: BoardListItem

    var body: some View {
        VStack {
            Text(boardItem.content)
            
            Spacer()
        }
        .padding()
        .navigationTitle(boardItem.title)
        .toolbar {
            ToolbarItem {
                Button("Edit") {
                    isShowingEditSheet = true // Show the edit sheet
                }
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            
        }
    }
}

#Preview {
    BoardDetailView(boardItem: .init(title: "Board Title", content: "Board Content", systemImageName: ""))
}
