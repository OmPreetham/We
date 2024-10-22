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

    // Local state to manage follow status and edit sheet
    @State private var isFollowing: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showingEditSheet: Bool = false
    
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
                                
                                Text("Created by \(board.userId)") // Ideally, display username
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        // Additional board details can be added here
                        Text(board.description)
                            .font(.body)
                            .padding(.top, 8)
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle(board.title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            // Follow/Unfollow Button
                            Button(action: {
                                if isFollowing {
                                    authViewModel.unfollowBoard(boardId: board.id)
                                    isFollowing = false
                                    alertMessage = "Successfully unfollowed the board."
                                    showSuccessAlert = true
                                } else {
                                    authViewModel.followBoard(boardId: board.id)
                                    isFollowing = true
                                    alertMessage = "Successfully followed the board."
                                    showSuccessAlert = true
                                }
                            }) {
                                Label(isFollowing ? "Unfollow" : "Follow", systemImage: isFollowing ? "minus.circle.fill" : "plus.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle(isFollowing ? .red : .accentColor)
                            }
                            .accessibilityLabel(isFollowing ? "Unfollow Board" : "Follow Board")
                            
                            // Edit Button (Only for Admins and Moderators)
                            if isAdminOrModerator {
                                Button(action: {
                                    showingEditSheet = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                        .labelStyle(.titleOnly)
                                }
                                .accessibilityLabel("Edit Board")
                            }
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
            checkIfFollowing()
        }
        .onChange(of: authViewModel.followedBoards) {
            checkIfFollowing()
        }
        .refreshable {
            checkIfFollowing()
            authViewModel.fetchBoard(by: boardId)
        }
        .sheet(isPresented: $showingEditSheet) {
            if let board = authViewModel.selectedBoard {
                EditBoardView(
                    title: .constant(board.title),
                    description: .constant(board.description),
                    symbolColor: .constant(board.symbolColor),
                    systemImageName: .constant(board.systemImageName)
                )
                .environmentObject(authViewModel)
                .onDisappear {
                    // Refresh board details after editing
                    authViewModel.fetchBoard(by: boardId)
                }
            }
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: Binding<Bool>(
            get: { authViewModel.errorMessage != nil },
            set: { _ in authViewModel.errorMessage = nil }
        )) {
            Alert(title: Text("Alert"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
    
    // Computed property to check if the user is admin or moderator
    private var isAdminOrModerator: Bool {
        guard let role = authViewModel.currentUser?.role else { return false }
        return role.lowercased() == "admin" || role.lowercased() == "moderator"
    }
    
    // Helper function to check follow status
    private func checkIfFollowing() {
        guard let board = authViewModel.selectedBoard else {
            isFollowing = false
            return
        }
        isFollowing = authViewModel.followedBoards.contains { $0.id == board.id }
    }
}

#Preview {
    NavigationView {
        BoardDetailView(boardId: "6716d55d9384d14d52370eec")
            .environmentObject(AuthViewModel())
    }
}
