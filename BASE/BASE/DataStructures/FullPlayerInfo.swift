//
//  FullPlayerInfo.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/11/25.
//

import Foundation

struct PlayerResponse: Decodable {
    let people: [PlayerInfo]
}

struct PlayerInfo: Decodable {
    let id: Int
    let fullName: String
    let link: String
    let firstName: String
    let lastName: String
    let primaryNumber: String?
    let birthDate: String
    let currentAge: Int
    let birthCity: String
    let birthCountry: String
    let height: String
    let weight: Int
    let active: Bool
    let primaryPosition: PlayerPosition
    let nickName: String?
    let gender: String
    let isPlayer: Bool
    let isVerified: Bool
    let pronunciation: String?
    let mlbDebutDate: String?
    let batSide: Side
    let pitchHand: PlayerSide
    let nameFirstLast: String
    let nameSlug: String
    let firstLastName: String
    let lastFirstName: String
    let lastInitName: String
    let initLastName: String
    let fullFMLName: String
    let fullLFMName: String
    let strikeZoneTop: Double
    let strikeZoneBottom: Double
}

struct PlayerPosition: Decodable {
    let code: String
    let name: String
    let type: String
    let abbreviation: String
}

struct PlayerSide: Decodable {
    let code: String
    let description: String
}
