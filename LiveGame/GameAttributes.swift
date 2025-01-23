//
//  GameData.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/4/25.
//

import Foundation
import ActivityKit
struct GameAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var homeScore: Int
        var awayScore: Int
    }

    var homeTeam: String
    var awayTeam: String
    var stadiumName: String
    var homeTeamImage: String
    var awayTeamImage: String
}
 
