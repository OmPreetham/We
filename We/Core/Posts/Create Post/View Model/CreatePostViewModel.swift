//
//  CreatePostViewModel.swift
//  We
//
//  Created by Om Preetham Bandi on 11/15/24.
//

import Foundation
import Combine

class CreatePostViewModel: ObservableObject {
    @Published var selectedBoard: Board?
    @Published var subject: String = ""
    @Published var content: String = ""
    @Published var username: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isSubmitting: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init(selectedBoard: Board? = nil, username: String? = nil) {
        self.selectedBoard = selectedBoard
        self.username = username ?? "userx99"
    }

    func validateFields() -> Bool {
        guard !subject.isEmpty, !content.isEmpty, selectedBoard != nil else {
            alertMessage = "All fields must be filled and a board selected."
            showAlert = true
            return false
        }
        return true
    }

    func createPost(onSuccess: @escaping () -> Void) {
        guard let boardId = selectedBoard?.id else {
            alertMessage = "Please select a board."
            showAlert = true
            return
        }

        isSubmitting = true
        alertMessage = ""

        PostService.shared.createPost(username: username, title: subject, content: content, boardId: boardId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isSubmitting = false
                switch result {
                case .success:
                    onSuccess()
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}
