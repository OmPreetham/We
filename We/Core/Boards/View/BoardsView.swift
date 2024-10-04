//
//  BoardsView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct BoardListItem: Identifiable {
    let id = UUID()
    let title: String
    var content: String
    let systemImageName: String
    
    // Static examples
    static let universityExamples = [
        BoardListItem(title: "Academic Affairs", content: "Oversees curriculum and academic standards", systemImageName: "book.closed"),
        BoardListItem(title: "Student Life", content: "Focuses on student engagement and campus activities", systemImageName: "person.fill"),
        BoardListItem(title: "Research Committee", content: "Manages research initiatives and funding", systemImageName: "magnifyingglass"),
        BoardListItem(title: "Finance Board", content: "Handles budgeting and financial planning for the university", systemImageName: "dollarsign.circle"),
        BoardListItem(title: "Ethics Committee", content: "Ensures all university activities uphold ethical standards", systemImageName: "scalemass"),
        BoardListItem(title: "Sports Committee", content: "Coordinates intercollegiate and intramural sports programs", systemImageName: "sportscourt")
    ]
}

struct BoardsView: View {
    @State private var searchText: String = ""
    
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
                .padding(.horizontal)
                .pickerStyle(.segmented)
                
                List(staticBoards) { item in
                    HStack {
                        Image(systemName: item.systemImageName)
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text(item.title).font(.headline)
                            Text(item.content).font(.subheadline)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Boards")
            .searchable(text: $searchText, prompt: "Search Boards")
        }
    }
}

#Preview {
    BoardsView()
}
