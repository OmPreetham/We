//
//  ReportPostSheetView.swift
//  We
//
//  Created by Om Preetham Bandi on 11/14/24.
//

import SwiftUI

struct ReportPostSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var postViewModel: PostDetailViewModel = PostDetailViewModel()

    @Binding var reportReason: String

    var postId: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TextField("Reason", text: $reportReason, axis: .vertical)
                }
                .padding()
            }
            .navigationTitle("Report Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Report") {
                        postViewModel.reportPost(postId: postId, reason: reportReason)
                        dismiss()
                    }
                    .tint(.red)
                    .disabled(reportReason.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ReportPostSheetView(reportReason: .constant(""),  postId: "samplePostId")
}
