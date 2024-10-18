//
//  BoardsListView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct BoardsListView: View {
    @State private var searchText: String = ""
    @State private var showingCreateBoard: Bool = false
    
    let options = ["All", "Following"]
    @State private var selectedOption = "All"
    
    let boards: [Board] = sampleBoards
    let posts: [Post] = samplePosts

    var filteredBoards: [Board] {
        // Filter boards based on the search text
        if searchText.isEmpty {
            return boards
        } else {
            return boards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Options", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                List(filteredBoards) { board in
                    HStack {
                        NavigationLink(destination: BoardDetailView(boardItem: board, posts: posts)) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.init(hex: board.symbolColor).gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Image(systemName: board.systemImageName)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 50, height: 50)
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                            .padding(.trailing, 8)

                            VStack(alignment: .leading) {
                                Text(board.title)
                                    .font(.headline)
                                
                                Text(board.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .lineLimit(3)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Boards")
            .toolbar {
                ToolbarItem {
                    Button {
                        showingCreateBoard.toggle()
                    } label: {
                        Label("Board", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .sheet(isPresented: $showingCreateBoard) {
                CreateBoardView()
            }
            .searchable(text: $searchText, prompt: "Search Boards")
        }
    }
}

#Preview {
    BoardsListView()
}
