//
//  FCInteractionStruct.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/16/25.
//

import Foundation

struct FanContentInteraction: Codable {
    let dateTimeDate: String
    let dateTimeUtc: String
    let source: String
    let userId: String
    let slug: String
    let contentType: String
    let contentHeadline: String
    let teamIds: [String]
    let playerTags: [String]
    
    enum CodingKeys: String, CodingKey {
        case dateTimeDate = "date_time_date"
        case dateTimeUtc = "date_time_utc"
        case source
        case userId = "user_id"
        case slug
        case contentType = "content_type"
        case contentHeadline = "content_headline"
        case teamIds = "team_ids"
        case playerTags = "player_tags"
    }
}
