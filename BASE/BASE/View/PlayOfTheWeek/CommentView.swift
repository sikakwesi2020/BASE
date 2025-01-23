//
//  CommentView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/2/25.
//

import Foundation
import SwiftUI


struct CommentView: View {
    let comment: CommentStructure
    let isReply: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("player1")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .background (
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.gradient, lineWidth: 1)
                        .frame(height: 40)
                )

            VStack(alignment: .leading) {
                HStack {
                    Text(comment.username)
                        .font(.caption) +  Text(" \(formatDate(comment.date))")  .font(.caption).foregroundColor(.gray)
                    Spacer()
                   
                }
                HStack(alignment: .top) {
//                    Rectangle()
//                        .fill(Color.gray)
//                        .frame(width: 2)
//                    
                    Text(comment.commentText)
                        .font(.callout)
                        //.padding()
                       // .background(isReply ? Color.gray.opacity(0.2) : Color.blue.opacity(0.1))
                      //  .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
               

                if isReply {
                    Text("↳ Replying to: \(comment.commentPlayer)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.leading, isReply ? 40 : 0)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // Example: Jan 2
        return formatter.string(from: date)
    }
}


#Preview {
    POTWView()
        .environmentObject(TeamsViewModel())
}
