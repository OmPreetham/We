//
//  AllBoardsView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/21/24.
//

import SwiftUI

struct AllBoardsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText: String = ""

    var filteredBoards: [Board] {
        if searchText.isEmpty {
            return authViewModel.allBoards
        } else {
            return authViewModel.allBoards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            if authViewModel.isLoadingAllBoards {
                ProgressView("Loading...")
                    .navigationTitle("All Boards")
            } else if filteredBoards.isEmpty {
                VStack {
                    Text("No boards available.")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .navigationTitle("All Boards")
            } else {
                List(filteredBoards) { board in
                    NavigationLink(destination: BoardDetailView(boardId: board.id)) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color(hex: board.symbolColor).gradient)
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
                .navigationTitle("All Boards")
                .searchable(text: $searchText, prompt: "Search Boards")
                .refreshable {
                    authViewModel.fetchAllBoards()
                }
            }
        }
        .onAppear {
            if authViewModel.allBoards.isEmpty {
                authViewModel.fetchAllBoards()
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { authViewModel.errorMessage != nil },
            set: { _ in authViewModel.errorMessage = nil }
        )) {
            Alert(title: Text("Error"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    AllBoardsView()
        .environmentObject(AuthViewModel())
}
