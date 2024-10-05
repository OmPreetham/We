//
//  BoardDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/4/24.
//

import SwiftUI

struct BoardDetailView: View {
    @Environment(\.dismiss) var dismiss

    @State private var showingEditBoardView = false
    
    @State private var followingBoard = false
    
    @State var boardItem: BoardListItem

    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    Rectangle()
                        .fill(boardItem.symbolColor)
                        .frame(width: 100, height: 100)
                        .clipShape(.rect(cornerRadius: 16))
                    
                    Image(systemName: boardItem.systemImageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                }
                .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                .padding()
                
                Text(boardItem.content)
            }
            .padding()
        }
        .navigationTitle(boardItem.title)
        .toolbar {
            ToolbarItem {
                Button {
                    followingBoard.toggle()
                } label: {
                    if followingBoard {
                        Label("Unfollow", systemImage: "checkmark")
                    } else {
                        Label("Follow", systemImage: "plus")
                    }
                }
                .buttonStyle(.bordered)
            }
            
            ToolbarItem {
                Button {
                    showingEditBoardView.toggle()
                } label: {
                    Label("Edit", systemImage: "slider.horizontal.3")
                }
                .buttonStyle(.bordered)
            }
        }
        .sheet(isPresented: $showingEditBoardView) {
            EditBoardView(title: $boardItem.title, content: $boardItem.content, symbolColor: $boardItem.symbolColor, systemImageName: $boardItem.systemImageName)
        }
    }
}

#Preview {
    BoardDetailView(boardItem: .init(title: "Board Title", content: "Board Content", symbolColor: .accentColor, systemImageName: ""))
}
