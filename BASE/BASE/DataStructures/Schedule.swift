//
//  Schedule.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/28/24.
//

import Foundation

// Struct to hold schedule data
struct Schedule: Decodable {
    let dates: [ScheduleDate]
}

struct ScheduleDate: Decodable {
    let date: String
    let games: [Game]
}

struct Game: Decodable {
    let gamePk: Int
    let gameDate: String
    let status: GameStatus
    let teams: GameTeams
    let venue: Venue
    let gameType: String
    let season: String
}

// Struct to hold full game detail data
struct GameDetail: Decodable {
    let copyright: String
    let gamePk: Int
    let link: String
    let metaData: MetaData
    let gameData: GameData
    let liveData: LiveData
}

struct MetaData: Decodable {
    let wait: Int
    let timeStamp: String
    let gameEvents: [String]
    let logicalEvents: [String]
}

struct GameData: Decodable {
    let game: GameInfo
    let datetime: GameDateTime
    let status: GameStatus
    let teams: GameTeams
    let venue: Venue
    let weather: Weather?
}

struct GameInfo: Decodable {
    let pk: Int
    let type: String
    let season: String
    let gameNumber: Int
    let calendarEventID: String
}

struct GameDateTime: Decodable {
    let dateTime: String
    let officialDate: String
    let dayNight: String
}

struct GameStatus: Decodable {
    let abstractGameState: String
    let detailedState: String
    let statusCode: String
}

struct GameTeams: Decodable {
    let away: TeamInfo
    let home: TeamInfo
}

struct TeamInfo: Decodable {
    let team: STeam
    let score: Int?
    let isWinner: Bool?
}

struct STeam: Decodable {
    let id: Int
    let name: String
}

struct Venue: Decodable {
    let id: Int
    let name: String
}

struct Weather: Decodable {
    let condition: String?
    let temp: String?
    let wind: String?
}

struct LiveData: Decodable {
    let plays: Plays?
    let linescore: Linescore?
    let boxscore: BoxScore
    let decisions: Decisions
    let leaders: Leaders
}

struct Plays: Decodable {
    let allPlays: [Plays]?
       let currentPlay: CurrentPlay?
       let scoringPlays: [ScoringPlay]?
       let playsByInning: [PlaysByInning]?
}

struct ScoringPlay: Decodable {
    
}

struct CurrentPlay: Decodable {
    
}


struct PlaysByInning: Decodable {
    
}




struct BoxScore: Decodable {
    let teams: BXTeams
    let officials: officials
    let info: info
    let pitchingNotes: pitchingNotes
    let topPerformers: topPerformers
}

struct home: Decodable {
    
}

struct away: Decodable {
    
}


struct officials: Decodable {
    
}

struct info: Decodable {
    
}

struct pitchingNotes: Decodable {
    
}

struct topPerformers: Decodable {
    
}

struct BXTeams: Decodable {
    let away: away?
    let home: home?
}

// New Decisions struct
struct Decisions: Decodable {
    let winner: Player
    let loser: Player
}

// New Leaders struct
struct Leaders: Decodable {
    let hitDistance: [LeaderStat]
    let hitSpeed: [LeaderStat]
    let pitchSpeed: [LeaderStat]
}


struct LeaderStat: Decodable {
    let id: Int
    let fullName: String
    let value: Double
}

struct Linescore: Decodable {
    let currentInning: Int
    let currentInningOrdinal: String
    let inningState: String
    let inningHalf: String
    let isTopInning: Bool
    let scheduledInnings: Int
    let innings: [Inning]
}

struct Inning: Decodable {
    let num: Int
    let ordinalNum: String
    let home: TeamStats
    let away: TeamStats
}

struct TeamStats: Decodable {
    let runs: Int
    let hits: Int
    let errors: Int
    let leftOnBase: Int
}
