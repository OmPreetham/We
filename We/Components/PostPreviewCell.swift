//
//  PostPreviewCell.swift
//  We
//
//  Created by Om Preetham Bandi on 10/7/24.
//

import SwiftUI

struct PostPreviewCell: View {
    var username: String = "@ShinjiIkari"
    var boardName: String = "NERV Headquarters"
    var postDate: String = "Mon, Sep 13 at 18:30"
    var postTitle: String = "Unit-01 Synchronization Issues"
    var postExcerpt: String = "Pilot report: Today’s synchronization test was more difficult than expected. The neural feedback loop from Unit-01 seemed unstable. Dr. Akagi suspects an AT Field interference, but no clear source was identified..."
    var replyCount: String = "1.5K"
    var upvoteCount: String = "5.2K"
    var downvoteCount: String = "300"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 2) {
                Text(username)
                
                Text("/")
                
                Text(boardName)
                
                Spacer()
                
                Text(postDate)
            }
            .font(.caption)
            
            VStack(alignment: .leading) {
                Text(postTitle)
                    .font(.headline)
                    .fontDesign(.serif)
                    .fontWeight(.bold)
                
                Text("")
                
                Text(postExcerpt)
                    .font(.callout)
                    .lineLimit(5)
            }
                        
            HStack {
                Button(action: {}) {
                    Label("Reply", systemImage: "arrowshape.turn.up.left")
                        .labelStyle(.iconOnly)
                    Text(replyCount)
                }
                .tint(.primary)
                
                Spacer()
                
                Button(action: {}) {
                    Label("Upvote", systemImage: "arrowshape.up")
                        .labelStyle(.iconOnly)
                    Text(upvoteCount)
                }
                .tint(.primary)
                
                Spacer()
                
                Button(action: {}) {
                    Label("Downvote", systemImage: "arrowshape.down")
                        .labelStyle(.iconOnly)
                    Text(downvoteCount)
                }
                .tint(.primary)
                
                Spacer()
                
                Button(action: {}) {
                    Label("Bookmark", systemImage: "bookmark")
                        .labelStyle(.iconOnly)
                }
                .tint(.primary)
            }
            .font(.callout)
        }
        .padding(12)
        
        Divider()
    }
}

#Preview {
    PostPreviewCell()
}
