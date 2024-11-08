//
//  ActivityView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/5/24.
//

import SwiftUI

struct ActivityView: View {
    @State private var selectedPicker = 0
    @ObservedObject var authViewModel = AuthViewModel()
        
    var body: some View {
        NavigationStack {
            ScrollView {
                Picker("Select Content", selection: $selectedPicker) {
                    Text("Posts").tag(0)
                    Text("Replies").tag(1)
                    Text("Upvotes").tag(2)
                    Text("Downvotes").tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Display content based on selectedPicker value
                Group {
                    if selectedPicker == 0 {
                        if authViewModel.isLoadingUserPosts {
                            ProgressView("Loading Posts...")
                                .padding()
                        } else if let error = authViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundStyle(.red)
                                .padding()
                        } else if authViewModel.userPosts.isEmpty {
                            ContentUnavailableView("No Posts", systemImage: "rectangle.portrait.slash", description: Text("There are currently no posts to display."))
                        } else {
                            PostListView(posts: authViewModel.userPosts)
                        }
                    } else if selectedPicker == 1 {
                        if authViewModel.isLoadingUserReplies {
                            ProgressView("Loading Replies...")
                                .padding()
                        } else if let error = authViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundStyle(.red)
                                .padding()
                        } else if authViewModel.userReplies.isEmpty {
                            ContentUnavailableView("No Posts", systemImage: "rectangle.portrait.slash", description: Text("There are currently no posts to display."))
                        } else {
                            PostListView(posts: authViewModel.userReplies)
                        }
                    } else if selectedPicker == 2 {
                        if authViewModel.isLoadingUserUpvotedPosts {
                            ProgressView("Loading Upvoted Posts...")
                                .padding()
                        } else if let error = authViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundStyle(.red)
                                .padding()
                        } else if authViewModel.userUpvotedPosts.isEmpty {
                            ContentUnavailableView("No Posts", systemImage: "rectangle.portrait.slash", description: Text("There are currently no posts to display."))
                        } else {
                            PostListView(posts: authViewModel.userUpvotedPosts)
                        }
                    } else if selectedPicker == 3 {
                        if authViewModel.isLoadingUserDownvotedPosts {
                            ProgressView("Loading Downvoted Posts...")
                                .padding()
                        } else if let error = authViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundStyle(.red)
                                .padding()
                        } else if authViewModel.userDownvotedPosts.isEmpty {
                            ContentUnavailableView("No Posts", systemImage: "rectangle.portrait.slash", description: Text("There are currently no posts to display."))
                        } else {
                            PostListView(posts: authViewModel.userDownvotedPosts)
                        }
                    }
                }
            }
            .navigationTitle("Activity")
            .onAppear {
                if authViewModel.currentUser == nil {
                    authViewModel.fetchCurrentUser()
                }
                fetchData()
            }
            .onChange(of: selectedPicker) {
                fetchData()
            }
            .refreshable {
                fetchData()
            }
        }
    }
    
    private func fetchData() {
        guard let userId = authViewModel.currentUser?.id else {
            return
        }
        switch selectedPicker {
        case 0:
            authViewModel.fetchUserPosts(userId: userId)
        case 1:
            authViewModel.fetchUserReplies(userId: userId)
        case 2:
            authViewModel.fetchUserUpvotedPosts(userId: userId)
        case 3:
            authViewModel.fetchUserDownvotedPosts(userId: userId)
        default:
            break
        }
    }
}
#Preview {
    ActivityView()
}
