//
//  Helper.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/12/25.
//

import Foundation
import Alamofire
import GoogleGenerativeAI



class StandingsHelper:ObservableObject {
    
    @Published var teamStandings: [StandingRecord] = []
    @Published var markdownReport: String = ""
    // Define the function
    
   
    
    private func fetchAndCombineStandings() async {
           let group = DispatchGroup()

           var standingsData: [StandingRecord] = []

           // Fetch data concurrently
           let urls = ["https://statsapi.mlb.com/api/v1/standings?leagueId=104", "https://statsapi.mlb.com/api/v1/standings?leagueId=103"]

           for urlString in urls {
               group.enter()
               Task {
                   do {
                       guard let url = URL(string: urlString) else {
                           throw URLError(.badURL)
                       }
                       let (data, _) = try await URLSession.shared.data(from: url)
                       let decoder = JSONDecoder()
                       let standings = try decoder.decode(MLBStandings.self, from: data)
                       
                       //Update UI on main thread
                       await MainActor.run {
                           standingsData.append(contentsOf: standings.records)
                       }
                   } catch {
                       print("Error fetching or decoding data from \(urlString): \(error)")
                       //Handle errors as needed in your app.
                   }
                   group.leave()
               }
           }
           
           group.notify(queue: .main) {
               //This will run after both fetch operations are complete.
               self.teamStandings = standingsData
           }
       }
    
    func generateSummaryJsonString(from records: [TeamRecord]) -> String? {
        let teamRecordsSummary = records.map { record in
          
            TeamRecordSummaryWithTeamsName(
                teamName: record.team.name,
                wins: record.wins,
                losses: record.losses,
                pct: record.winningPercentage,
                gamesBehind: record.gamesBack,
                wildCardGamesBehind: record.wildCardGamesBack,
                streak: record.streak.streakType == "wins" ? record.streak.streakNumber : -record.streak.streakNumber,
                runsScored: record.runsScored,
                runsAllowed: record.runsAllowed
            )
        }
        
        do {
            let jsonData = try JSONEncoder().encode(teamRecordsSummary)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding team records to JSON: \(error)")
            return nil
        }
    } 
    
    func runAnalytics(jsonSummary: String, responseLanguage: String, apiKey: String) async -> String? {
        let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: apiKey)
        // Build the prompt
            let prompt = """
            Analyze the following JSON data of league standings for the season, generate a detailed markdown report of the league's performance, including key highlights, trends, and a summary of the season. Provide predictions for the next season based on the data. Respond in \(responseLanguage).

            JSON Data:
            \(jsonSummary)
            """
      
        do {
            let response = try await model.generateContent(prompt)
          
            // Extract and return the AI's generated markdown response
                   if let markdownResponse = response.candidates.first?.content.parts.first?.text {
                       return markdownResponse
                   } else {
                       print("No valid response from the AI.")
                       return nil
                   }
            
            
        } catch {
            print("error occured: \(error)")
            return nil
        }
    }
    
    func runc() async {
        await fetchAndCombineStandings()
    }

    
    
//    func runc() {
//        
//        let link1 =  URL(string: "https://statsapi.mlb.com/api/v1/standings?leagueId=104")!
//        let link2 =  URL(string: "https://statsapi.mlb.com/api/v1/standings?leagueId=103")!
//      
//        do {
//            let jsonData = try! Data(contentsOf: URL(string: "https://statsapi.mlb.com/api/v1/standings?leagueId=104")!)
//            let decoder = JSONDecoder()
//            let standings = try decoder.decode(MLBStandings.self, from: jsonData)
//           
//            teamStandings = standings.records
//            
//        } catch {
//            print("Error decoding JSON: \(error)") // Log the error for debugging
//            // Handle the error appropriately, e.g., display a user-friendly message
//        }
//
//      
//     
//    }
    
    func getTeamRecords(forTeamId teamId: Int) -> [TeamRecord] {
        return teamStandings.flatMap { $0.teamRecords.filter { $0.team.id == teamId } }
    }
    
    

}
