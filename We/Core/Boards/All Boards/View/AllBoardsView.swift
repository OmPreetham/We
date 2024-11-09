//
//  AllBoardsView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/21/24.
//

import SwiftUI

struct AllBoardsView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @StateObject private var viewModel: AllBoardsViewModel
    
    init(authViewModel: AuthViewModel) {
        _viewModel = StateObject(wrappedValue: AllBoardsViewModel(authViewModel: authViewModel))
    }

    var body: some View {
        NavigationStack {
            if viewModel.isLoadingAllBoards {
                ProgressView("Loading...")
                    .navigationTitle("All Boards")
            } else if viewModel.filteredBoards.isEmpty {
                VStack {
                    Text("No boards available.")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .navigationTitle("All Boards")
            } else {
                List(viewModel.filteredBoards) { board in
                    NavigationLink(destination: BoardDetailView(boardId: board.id, authViewModel: authViewModel)) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color(hex: board.symbolColor).gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                Image(systemName: board.systemImageName)
                                    .foregroundStyle(.background)
                            }
                            .frame(width: 50, height: 50)
                            .shadow(color: .secondary.opacity(0.3), radius: 4, x: 0, y: 0)
                            .padding(.trailing, 8)

                            VStack(alignment: .leading) {
                                Text(board.title)
                                    .font(.headline)
                                    .lineLimit(1)

                                Text(board.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
                .navigationTitle("All Boards")
                .searchable(text: $viewModel.searchText, prompt: "Search Boards")
                .refreshable {
                    viewModel.fetchAllBoards()
                }
            }
        }
        .onAppear {
            if viewModel.allBoards.isEmpty {
                viewModel.fetchAllBoards()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("All Boards Alert"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    AllBoardsView(authViewModel: AuthViewModel())
}
