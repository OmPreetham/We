//
//  CommunitiesView.swift
//  We
//
//  Created by Om Preetham Bandi on 8/10/24.
//

import SwiftUI

struct BoardsView: View {
    @State private var showingCreateBoard: Bool = false
    @State private var searchText: String = ""
    
    var boards: [Board]? = Board.mockBoards
    
    var body: some View {
        NavigationStack {
            if let boards = boards, !boards.isEmpty {
                List {
                    ForEach(boards) { board in
                        NavigationLink(value: board) {
                            HStack(spacing: 16) {
                                Image(systemName: board.systemImageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(board.name)
                                        .fontWeight(.semibold)
                                    
                                    Text(board.content)
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(3)
                                }
                            }
                        }
                    }
                }
                .navigationDestination(for: Board.self, destination: { board in
                    BoardView(board: board)
                })
                .navigationTitle("Boards")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingCreateBoard.toggle()
                        } label: {
                            Label("New Community", systemImage: "plus")
                        }
                        
                    }
                }
                .sheet(isPresented: $showingCreateBoard) {
                    CreateBoard()
                        .presentationDetents([.medium, .large])
                }
            } else {
                ContentUnavailableView("No Boards", systemImage: "people.3.fill", description: Text("There are no boards available."))
            }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    BoardsView()
}
