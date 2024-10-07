//
//  BoardsListView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct BoardListItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var content: String
    var symbolColor: Color
    var systemImageName: String
    
    // Static examples
    static let universityExamples = [
        BoardListItem(title: "Academic Affairs", content: "Oversees curriculum and academic standards", symbolColor: .blue, systemImageName: "book.closed"),
        BoardListItem(title: "Student Life", content: "Focuses on student engagement and campus activities", symbolColor: .red, systemImageName: "person.fill"),
        BoardListItem(title: "Research Committee", content: "Manages research initiatives and funding", symbolColor: .orange, systemImageName: "magnifyingglass"),
        BoardListItem(title: "Finance Board", content: "Handles budgeting and financial planning for the university", symbolColor: .yellow, systemImageName: "dollarsign.circle"),
        BoardListItem(title: "Ethics Committee", content: "Ensures all university activities uphold ethical standards", symbolColor: .brown, systemImageName: "scalemass"),
        BoardListItem(title: "Sports Committee", content: "Coordinates intercollegiate and intramural sports programs", symbolColor: .purple, systemImageName: "sportscourt")
    ]
}

struct BoardsListView: View {
    @State private var searchText: String = ""
    
    @State private var showingCreateBoard: Bool = false
    
    let options = ["All", "Following"]
    @State private var selectedOption = "All"
    
    let staticBoards = BoardListItem.universityExamples
    
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
                
                List(staticBoards) { item in
                    HStack {
                        NavigationLink(destination: BoardDetailView(boardItem: item)) {
                            ZStack {
                                Rectangle()
                                    .fill(item.symbolColor.gradient.materialActiveAppearance(.automatic))
                                    .clipShape(.rect(cornerRadius: 8))
                                
                                Image(systemName: item.systemImageName)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 50, height: 50)
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                            .padding(.trailing, 8)

                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                
                                Text(item.content)
                                    .font(.subheadline)
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
                    .buttonStyle(.bordered)
                    .clipShape(.capsule)
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
