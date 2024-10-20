//
//  NavigationSidebarView.swift
//  We
//
//  Created by Om Preetham Bandi on 10/19/24.
//

import SwiftUI

struct NavigationSidebarView: View {
    @Binding var primarySelection: NavigateView.PrimarySelection?

    @State private var username: String = "ShinjiIkariUnit01"
    
    var body: some View {
        List(selection: $primarySelection) {
            Section {
                NavigationLink(value: NavigateView.PrimarySelection.account) {
                    SidebarItemView(
                        title: username,
                        description: "We Account, Personalization, and more.",
                        imageName: "person.fill",
                        gradientColor: .teal,
                        isAccount: true
                    )
                }
            }

            Section(header: Text("Personalized")) {
                NavigationLink(value: NavigateView.PrimarySelection.forYou) {
                    SidebarItemView(
                        title: "For You",
                        description: "A curated feed based on your interests.",
                        imageName: "shared.with.you",
                        gradientColor: .blue
                    )
                }
                
                NavigationLink(value: NavigateView.PrimarySelection.followingPosts) {
                    SidebarItemView(
                        title: "Following",
                        description: "Posts from people you follow.",
                        imageName: "checkmark.seal.fill",
                        gradientColor: Color(red: 212/255, green: 175/255, blue: 55/255)
                    )
                }
            }

            Section(header: Text("Boards")) {
                ForEach(sampleBoards) { board in
                    NavigationLink(value: NavigateView.PrimarySelection.board(board.id)) {
                        SidebarItemView(
                            title: board.title,
                            description: board.description,
                            imageName: board.systemImageName,
                            gradientColor: Color(hex: board.symbolColor)
                        )
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("III")
        .searchable(text: .constant(""))
        .refreshable {
            
        }
    }
}

#Preview {
    NavigationSidebarView(primarySelection: Binding(.constant(.forYou)))
}
