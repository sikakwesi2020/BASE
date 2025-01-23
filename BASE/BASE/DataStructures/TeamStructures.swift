//
//  TeamStructures.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/27/24.
//

import Foundation


struct TeamsResponse: Decodable {
    let copyright: String
    let teams: [Team]
}

struct Team: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let abbreviation: String
    let locationName: String
    let teamName: String
    let leagueName: String

    enum CodingKeys: String, CodingKey {
        case id, name, abbreviation, locationName, teamName, league
    }

    enum LeagueKeys: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        abbreviation = try container.decode(String.self, forKey: .abbreviation)
        locationName = try container.decode(String.self, forKey: .locationName)
        teamName = try container.decode(String.self, forKey: .teamName)

        let leagueContainer = try container.nestedContainer(keyedBy: LeagueKeys.self, forKey: .league)
        leagueName = try leagueContainer.decode(String.self, forKey: .name)
    }
}
