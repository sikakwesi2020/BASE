//
//  Roster.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/28/24.
//

import Foundation
// Struct to decode player roster data
struct RosterResponse: Decodable {
    let copyright: String
    let roster: [Player]
}

struct PlayerProfile: Decodable {
    let player: Player
    let team: Team
}

struct Player: Decodable {
    let person: Person
    let jerseyNumber: String
    let position: Position
    let status: PlayerStatus
    //let parentTeamId: Int
}

struct Person: Decodable {
    let id: Int
    let fullName: String
    let link: String
}

struct Position: Decodable {
    let code: String
    let name: String
    let type: String
    let abbreviation: String
}

struct PlayerStatus: Decodable {
    let code: String
    let description: String
}
