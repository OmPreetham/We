//
//  BoardDetailView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/20/24.
//

import SwiftUI

struct BoardDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var boardId: String
    
    var body: some View {
        VStack {
            if authViewModel.isLoadingSelectedBoard {
                ProgressView("Loading...")
                    .navigationTitle("Board Details")
            } else if let board = authViewModel.selectedBoard {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color(hex: board.symbolColor).gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: board.systemImageName)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 50, height: 50)
                            }
                            .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 3)
                            
                            VStack(alignment: .leading) {
                                Text(board.title)
                                    .font(.largeTitle)
                                    .bold()
                                
                                Text(board.description)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        // Display user info
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(board.userId)
                                    .font(.headline)
                            }
                        }
                        
                        // Add other board details or actions here
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle(board.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Example action: follow/unfollow
                            // Implement follow/unfollow functionality if desired
                        }) {
                            Text("Action")
                        }
                    }
                }
            } else {
                Text("Board not found.")
                    .foregroundStyle(.secondary)
                    .navigationTitle("Board Details")
            }
        }
        .onAppear {
            authViewModel.fetchBoard(by: boardId)
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
    BoardDetailView(boardId: "6716d55d9384d14d52370eec")
        .environmentObject(AuthViewModel())
}
