//
//  CommentStructure.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/2/25.
//

import Foundation
struct CommentStructure: Identifiable {
    let id: String
    let commentText: String
    let commentPlayer: String
    let isReply: Bool
    let mainContentId: String? // Will hold the ID of the main comment if this is a reply
    let commenterProfilePic: String
    let username: String
    let date: Date
}
