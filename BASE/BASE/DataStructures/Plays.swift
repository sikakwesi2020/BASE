//
//  Plays.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/10/25.


import Foundation

struct PlayEvent: Codable {
    let type: String
    let index: Int
    let player: GPlayer?
    let startTime: String
    let endTime: String
    let isPitch: IsPitch
    let count: Count
    let details: Details
    let pitchData: PitchData?
    let hitData: HitData?
    let playId: String?
    let pitchNumber: Int?
}

struct GPlayer: Codable {
    let id: Int
    let link: String
}

struct Count: Codable {
    let balls: Int
    let outs: Int
    let strikes: Int
}

struct Details: Codable {
    let awayScore: Int
    let homeScore: Int
    let description: String
    let event: String
    let eventType: String
    let hasReview: HasReview
    let isOut: Int
    let isScoringPlay: Int
}

struct PitchData: Codable {
    let breaks: [String: String]
    let coordinates: Coordinates
    let strikeZoneBottom: String
    let strikeZoneTop: String
}

struct Coordinates: Codable {
    let x: String
    let y: String
}

struct HitData: Codable {
    let coordinates: HitCoordinates
    let hardness: String
    let location: Int
    let trajectory: String
}

struct HitCoordinates: Codable {
    let coordX: String
    let coordY: String
}

// Decoding the data
struct GamePlays: Codable {
    let playEvents: [PlayEvent]
}

enum IsPitch: Codable {
    case bool(Bool)
    case int(Int)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else {
            throw DecodingError.typeMismatch(
                IsPitch.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected Int or Bool for isPitch"
                )
            )
        }
    }
    
    func valueAsBool() -> Bool {
        switch self {
        case .bool(let boolValue): return boolValue
        case .int(let intValue): return intValue != 0
        }
    }
}

enum HasReview: Codable {
    case bool(Bool)
    case int(Int)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else {
            throw DecodingError.typeMismatch(
                HasReview.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected Int or Bool for hasReview"
                )
            )
        }
    }
    
    func valueAsBool() -> Bool {
        switch self {
        case .bool(let boolValue): return boolValue
        case .int(let intValue): return intValue != 0
        }
    }
}








//
//import Foundation
//struct Play: Decodable {
//    let result: PlayResult
//    let about: About
//    let count: Count
//    let matchup: Matchup
//    let pitchIndex: [Int]
//    let actionIndex: [Int]
//    let runnerIndex: [Int]
//    let runners: [Runner]
//    let playEvents: [PlayEvent]
//    let playEndTime: String
//    let atBatIndex: Int
//}
//
//struct PlayResult: Decodable {
//    let type: String
//    let event: String
//    let eventType: String
//    let description: String
//    let rbi: Int
//    let awayScore: Int
//    let homeScore: Int
//    let isOut: Bool
//}
//
//struct About: Decodable {
//    let atBatIndex: Int
//    let halfInning: String
//    let isTopInning: Bool
//    let inning: Int
//    let startTime: String
//    let endTime: String
//    let isComplete: Bool
//    let isScoringPlay: Bool
//    let hasReview: Bool
//    let hasOut: Bool
//    let captivatingIndex: Int
//}
//
//struct Count: Decodable {
//    let balls: Int
//    let strikes: Int
//    let outs: Int
//}
//
//struct Matchup: Decodable {
//    let batter: player
//    let batSide: Side
//    let pitcher: player
//    let pitchHand: Side
//    let batterHotColdZones: [String] // Array of any type if needed
//    let pitcherHotColdZones: [String] // Array of any type if needed
//    let splits: Splits
//}
//
//struct player: Decodable {
//    let id: Int
//    let fullName: String
//    let link: String
//}
//
struct Side: Decodable {
    let code: String
    let description: String
}
//
//struct Splits: Decodable {
//    let batter: String
//    let pitcher: String
//    let menOnBase: String
//}
//
//struct Runner: Decodable {
//    let movement: Movement
//    let details: RunnerDetails
//    let credits: [Credit]
//}
//
//struct Movement: Decodable {
//    let originBase: String?
//    let start: String?
//    let end: String?
//    let outBase: String?
//    let isOut: Bool
//    let outNumber: Int?
//}
//
//struct RunnerDetails: Decodable {
//    let event: String
//    let eventType: String
//    let movementReason: String?
//    let runner: player
//    let responsiblePitcher: String?
//    let isScoringEvent: Bool
//    let rbi: Bool
//    let earned: Bool
//    let teamUnearned: Bool
//    let playIndex: Int
//}
//
//struct creditPlayer: Decodable {
//    let id: Int
//    let link: String
//}
//
//struct Credit: Decodable {
//    let player: creditPlayer
//    let position: Position
//    let credit: String
//}
// 
// 
//
//struct PlayEvent: Decodable {
//    let details: EventDetails
//    let count: Count
//    let pitchData: PitchData?
//    let hitData: HitData?
//    let index: Int
//    let playId: String
//    let pitchNumber: Int?
//    let startTime: String
//    let endTime: String
//    let isPitch: Bool
//    let type: String
//}
//
//struct EventDetails: Decodable {
//    let call: Call?
//    let description: String
//    let event: String
//    let eventType: String
//    let ballColor: String?
//    let trailColor: String?
//    let isInPlay: Bool?
//    let isStrike: Bool?
//    let isBall: Bool?
//    let type: TypeInfo?
//    let isOut: Bool
//    let hasReview: Bool
//}
//
//struct Call: Decodable {
//    let code: String
//    let description: String
//}
//
//struct TypeInfo: Decodable {
//    let code: String
//    let description: String
//}
//
//struct PitchData: Decodable {
//    let startSpeed: Double
//    let endSpeed: Double
//    let strikeZoneTop: Double
//    let strikeZoneBottom: Double
//    let coordinates: Coordinates
//    let breaks: Breaks
//    let zone: Int
//    let typeConfidence: Int
//    let plateTime: Double
//    let `extension`: Double
//}
//
//struct Coordinates: Decodable {
//    let aY: Double
//    let aZ: Double
//    let pfxX: Double
//    let pfxZ: Double
//    let pX: Double
//    let pZ: Double
//    let vX0: Double
//    let vY0: Double
//    let vZ0: Double
//    let x: Double
//    let y: Double
//    let x0: Double
//    let y0: Double
//    let z0: Double
//    let aX: Double
//}
//
//struct Breaks: Decodable {
//    let breakAngle: Double
//    let breakLength: Double
//    let breakY: Double
//    let breakVertical: Double
//    let breakVerticalInduced: Double
//    let breakHorizontal: Double
//    let spinRate: Int
//    let spinDirection: Int
//}
//
//struct HitData: Decodable {
//    let launchSpeed: Double
//    let launchAngle: Double
//    let totalDistance: Int
//    let trajectory: String
//    let hardness: String
//    let location: String
//    let coordinates: HitCoordinates
//}
//
//struct HitCoordinates: Decodable {
//    let coordX: Double
//    let coordY: Double
//}
