//
//  StandingsStructures.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/12/25.
//

import Foundation
import Alamofire
import SwiftUI


struct TeamStandingStats: Codable {
   // var id = UUID()
       var rank: String?
       var teamName: String?
       var wins: String?
       var losses: String?
       var winLossPercentage: String?
       var streak: String?
       var runs: String?
       var runsAgainst: String?
       var runDifference: String?
       var strengthOfSchedule: String?
       var srs: String?
       var pythW_L: String?
       var luck: String?
       var vEast: String?
       var vCent: String?
       var vWest: String?
       var interleague: String?
       var home: String?
       var road: String?
       var extraInnings: String?
       var oneRunGames: String?
       var vsRHP: String?
       var vsLHP: String?
       var greaterThan500: String?
       var lessThan500: String?
       var last10: String?
       var last20: String?
       var last30: String?
    }



struct MLBStandings: Decodable, Identifiable {
    let copyright: String
    let records: [StandingRecord]
    
    var id: String { copyright }
}

struct StandingRecord: Decodable, Identifiable {
    let standingsType: String
    let league: League
    let division: Division
    let sport: Sport
    let lastUpdated: String
    let teamRecords: [TeamRecord]
    
    var id: String { league.id.description + division.id.description }
}

struct League: Decodable, Identifiable {
    let id: Int
    let link: String
    
    //var id: String { id.description }
}

struct Division: Decodable, Identifiable {
    let id: Int
    let link: String
    
   // var id: String { id.description }
}

struct Sport: Decodable, Identifiable {
    let id: Int
    let link: String
    
   // var id: String { id.description }
}


struct TeamRecord: Decodable, Identifiable {
    let team: StandingTeam
    let season: String
    let streak: Streak
    let clinchIndicator: String?
    let divisionRank: String
    let leagueRank: String
    let wildCardRank: String? // Optional since not all teams have a wildcard rank
    let sportRank: String
    let gamesPlayed: Int
    let gamesBack: String
    let wildCardGamesBack: String
    let leagueGamesBack: String
    let springLeagueGamesBack: String
    let sportGamesBack: String
    let divisionGamesBack: String
    let conferenceGamesBack: String
    let leagueRecord: LeagueRecord
    let lastUpdated: String
    let records: Records
    let runsAllowed: Int
    let runsScored: Int
    let divisionChamp: Bool
    let divisionLeader: Bool
    let wildCardLeader: Bool? //Optional
    let hasWildcard: Bool
    let clinched: Bool
    let eliminationNumber: String
    let eliminationNumberSport: String
    let eliminationNumberLeague: String
    let eliminationNumberDivision: String
    let eliminationNumberConference: String
    let wildCardEliminationNumber: String
    let magicNumber: String?
    let wins: Int
    let losses: Int
    let runDifferential: Int
    let winningPercentage: String
    
    var id: Int { team.id }
}

struct StandingTeam: Decodable, Identifiable {
    let id: Int
    let name: String
    let link: String
    
    //var id: Int { id }
}

struct Streak: Decodable {
    let streakType: String
    let streakNumber: Int
    let streakCode: String
}

struct LeagueRecord: Decodable {
    let wins: Int
    let losses: Int
    let ties: Int?
    let pct: String
}

struct Records: Decodable {
    let splitRecords: [SplitRecord]
    let divisionRecords: [DivisionRecord]
    let overallRecords: [OverallRecord]
    let leagueRecords: [LeagueRecord]
    let expectedRecords: [ExpectedRecord]
}

struct SplitRecord: Decodable {
    let wins: Int
    let losses: Int
    let type: String
    let pct: String
}

struct DivisionRecord: Decodable {
    let wins: Int
    let losses: Int
    let pct: String
    let division: DivisionDetails
}

struct DivisionDetails: Decodable, Identifiable {
    let id: Int
    let name: String
    let link: String
   // var id: String { id.description }
}

struct OverallRecord: Decodable {
    let wins: Int
    let losses: Int
    let type: String
    let pct: String
}

struct LeagueRecord2: Decodable { //Renamed to avoid conflict with LeagueRecord in Records struct
    let wins: Int
    let losses: Int
    let pct: String
    let league: LeagueDetails
}

struct LeagueDetails: Decodable, Identifiable {
    let id: Int
    let name: String
    let link: String
   // var id: String { id.description }
}

struct ExpectedRecord: Decodable {
    let wins: Int
    let losses: Int
    let type: String
    let pct: String
}



struct TeamRecordSummary: Identifiable, Hashable, Encodable { //For use in the ScrollView
    let id = UUID()
    let wins: Int
    let losses: Int
    let pct: String
    let gamesBehind: String
    let wildCardGamesBehind: String
    let streak: Int //Streak is an integer, negative for losses
    let runsScored: Int
    let runsAllowed: Int
}

struct TeamRecordSummaryWithTeamsName:  Hashable, Encodable { //For use in the ScrollView
   
    let teamName: String
    let wins: Int
    let losses: Int
    let pct: String
    let gamesBehind: String
    let wildCardGamesBehind: String
    let streak: Int //Streak is an integer, negative for losses
    let runsScored: Int
    let runsAllowed: Int
}


extension StandingRecord {
    var sortedTeamRecords: [TeamRecord] {
        teamRecords.sorted {
            // Convert leagueRank to Int for numerical comparison
            guard let rank1 = Int($0.leagueRank), let rank2 = Int($1.leagueRank) else {
                return false // Keep order if conversion fails
            }
            return rank1 < rank2
        }
    }
}
