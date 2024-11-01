//
//  FollowedBoardsView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/3/24.
//

import SwiftUI

struct FollowedBoardsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText: String = ""

    var filteredBoards: [Board] {
        if searchText.isEmpty {
            return authViewModel.followedBoards
        } else {
            return authViewModel.followedBoards.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            if authViewModel.isLoadingFollowedBoards {
                ProgressView("Loading...")
                    .navigationTitle("Followed Boards")
            } else if filteredBoards.isEmpty {
                VStack {
                    Text("You are not following any boards yet.")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .navigationTitle("Followed Boards")
            } else {
                List(filteredBoards) { board in
                    NavigationLink(destination: BoardDetailView(boardId: board.id)) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color(hex: board.symbolColor).gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                Image(systemName: board.systemImageName)
                                    .foregroundStyle(.background)
                            }
                            .frame(width: 50, height: 50)
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
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
                .navigationTitle("Followed Boards")
                .searchable(text: $searchText, prompt: "Search Boards")
                .refreshable {
                    authViewModel.fetchFollowedBoards()
                }
            }
        }
        .onAppear {
            if authViewModel.followedBoards.isEmpty {
                authViewModel.fetchFollowedBoards()
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { authViewModel.errorMessage != nil },
            set: { _ in authViewModel.errorMessage = nil }
        )) {
            Alert(title: Text("Alert"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
        .refreshable {
            authViewModel.fetchFollowedBoards()
        }
    }
}

#Preview {
    FollowedBoardsView()
        .environmentObject(AuthViewModel())
}
