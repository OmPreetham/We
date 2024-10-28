//
//  MyBoardsView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct MyBoardsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText: String = ""

    var filteredBoards: [Board] {
        if searchText.isEmpty {
            return authViewModel.userBoards
        } else {
            return authViewModel.userBoards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredBoards) { board in
                NavigationLink(destination: BoardDetailView(boardId: board.id)) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(Color(hex: board.symbolColor).materialActiveAppearance(.active))
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            Image(systemName: board.systemImageName)
                                .foregroundStyle(.primary)
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
            .navigationTitle("My Boards")
            .searchable(text: $searchText, prompt: "Search Boards")
            .onAppear {
                if authViewModel.userBoards.isEmpty {
                    authViewModel.fetchUserBoards()
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { authViewModel.errorMessage != nil },
                set: { _ in authViewModel.errorMessage = nil }
            )) {
                Alert(title: Text("Alert"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    MyBoardsView()
        .environmentObject(AuthViewModel())
}
