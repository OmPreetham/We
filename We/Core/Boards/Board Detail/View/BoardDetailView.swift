//
//  BoardDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct BoardDetailView: View {
    @Environment(\.dismiss) var dismiss

    @State private var showingEditBoard = false
    
    @State private var followingBoard = false
    
    @State var boardItem: BoardListItem

    var body: some View {
        ZStack {
            PostListView()
        }
        .navigationTitle(boardItem.title)
        .toolbar {
            ToolbarItem {
                Button {
                    followingBoard.toggle()
                } label: {
                    if followingBoard {
                        Label("Unfollow", systemImage: "checkmark.circle.fill")
                    } else {
                        Label("Follow", systemImage: "plus")
                    }
                }
            }
            
            ToolbarItem {
                Button {
                    showingEditBoard.toggle()
                } label: {
                    Label("Edit", systemImage: "slider.horizontal.3")
                }
            }
        }
        .sheet(isPresented: $showingEditBoard) {
            EditBoardView(title: $boardItem.title, content: $boardItem.content, symbolColor: $boardItem.symbolColor, systemImageName: $boardItem.systemImageName)
        }
    }
}

#Preview {
    BoardDetailView(boardItem: .init(title: "Board Title", content: "Board Content", symbolColor: .accentColor, systemImageName: ""))
}
