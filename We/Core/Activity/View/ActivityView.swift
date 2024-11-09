//
//  ActivityView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/5/24.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @ObservedObject var activityViewModel: ActivityViewModel = ActivityViewModel()
    
    @State private var selectedPicker: Int = 0
    
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
                        if activityViewModel.isLoadingUserPosts {
                            ProgressView()
                                .padding()
                        } else if let error = activityViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundStyle(.red)
                                .padding()
                        } else if activityViewModel.userPosts.isEmpty {
                            ContentUnavailableView("No Posts", systemImage: "rectangle.portrait.slash", description: Text("There are currently no posts to display."))
                        } else {
                            PostListView(posts: activityViewModel.userPosts)
                        }
                    } else if selectedPicker == 1 {
                        if activityViewModel.isLoadingUserReplies {
                            ProgressView()
                                .padding()
                        } else if let error = activityViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundStyle(.red)
                                .padding()
                        } else if activityViewModel.userReplies.isEmpty {
                            ContentUnavailableView("No Replies", systemImage: "rectangle.portrait.slash", description: Text("There are currently no replies to display."))
                        } else {
                            PostListView(posts: activityViewModel.userReplies)
                        }
                    } else if selectedPicker == 2 {
                        if activityViewModel.isLoadingUserUpvotedPosts {
                            ProgressView()
                                .padding()
                        } else if let error = activityViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundStyle(.red)
                                .padding()
                        } else if activityViewModel.userUpvotedPosts.isEmpty {
                            ContentUnavailableView("No Upvotes", systemImage: "rectangle.portrait.slash", description: Text("There are currently no upvoted posts to display."))
                        } else {
                            PostListView(posts: activityViewModel.userUpvotedPosts)
                        }
                    } else if selectedPicker == 3 {
                        if activityViewModel.isLoadingUserDownvotedPosts {
                            ProgressView()
                                .padding()
                        } else if let error = activityViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundStyle(.red)
                                .padding()
                        } else if activityViewModel.userDownvotedPosts.isEmpty {
                            ContentUnavailableView("No Downvotes", systemImage: "rectangle.portrait.slash", description: Text("There are currently no downvoted posts to display."))
                        } else {
                            PostListView(posts: activityViewModel.userDownvotedPosts)
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
            activityViewModel.fetchUserPosts(userId: userId)
        case 1:
            activityViewModel.fetchUserReplies(userId: userId)
        case 2:
            activityViewModel.fetchUserUpvotedPosts(userId: userId)
        case 3:
            activityViewModel.fetchUserDownvotedPosts(userId: userId)
        default:
            break
        }
    }
}

#Preview {
    ActivityView()
}
