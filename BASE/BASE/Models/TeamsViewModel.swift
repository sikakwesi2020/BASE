//
//  TeamsViewModel.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/27/24.
//

import SwiftUI
import Alamofire
import ActivityKit
import Combine


class TeamsViewModel: ObservableObject {
    @Published var teams: [Team] = []
    @Published var selectedFavourites: [Team] = []
    
    @Published var seasonSchedule:Schedule?
    @Published var filteredGames: [Game] = []
    @Published var OurfilteredGames: [Game] = []
    @Published var favouritePlayers:[PlayerProfile] = []
    @Published var homeRunData: [HomeRun] = []
    
    // Fanbase -- Next Games
    @Published var openSingleGame:Bool = false
    @Published var openSingleGameData:Game?
    @Published var openSingleGameTab:String = "home"
    @Published var accessToken:String = ""
    
    @Published var needsRestart: Bool = false
    @Published var viewneedsRestart: Bool = false
    
    @Published var fangameData: [String: Any] = [:] // Entire JSON as a dictionary
    @Published var singleAllPlays: [[String: Any]] = [] // Extracted allPlays as an array of dictionaries
    private var cancellables = Set<AnyCancellable>()
    
    @Published var teamFavorites: [(teamId: String, numFavorites: Int)] = []
    private let url = URL(string: "https://storage.googleapis.com/gcp-mlb-hackathon-2025/datasets/mlb-fan-content-interaction-data/2025-mlb-fan-favs-follows.json")!

   
    
    
    @Published var selectedDay: Date = {
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 23
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    @Published var OurNextGameDay: Date = {
        var components = DateComponents()
        components.year = 2024
        components.month = 10
        components.day = 23
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    
    
    func generateMLBVideoURL(playId: String) -> String {
        return "https://www.mlb.com/video/search?q=playid=\"\(playId)\""
    }
    
    func fetchVideoURL(for playId: String, from urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            // Convert data into lines
            if let csvString = String(data: data, encoding: .utf8) {
                let lines = csvString.split(separator: "\n")
                for line in lines {
                    let columns = line.split(separator: ",") // Assuming CSV is comma-separated
                    if columns.first! == playId {
                        completion(String(columns.last ?? "")) // Assuming the video link is the last column
                        return
                    }
                }
            }
            
            completion(nil) // Play ID not found
        }
        
        task.resume()
    }
    
    func fetchSingleGameData(gamePK: Int, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let urlString = "https://statsapi.mlb.com/api/v1.1/game/\(gamePK)/feed/live"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data -> [String: Any] in
                // Parse the JSON into a dictionary
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    throw URLError(.badServerResponse)
                }
                return json
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    print("Error fetching game data: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] json in
               // self?.gameDetailJSON = json // Store the JSON in the state variable
                completion(.success(json))  // Return the JSON through the completion handler
            })
            .store(in: &cancellables)
    }
    
//    func fetchSingleGameData(gamePK: Int, completion: @escaping (GameDetail) -> Void) {
//        let urlString = "https://statsapi.mlb.com/api/v1.1/game/\(gamePK)/feed/live"
//        guard let url = URL(string: urlString) else { return }
//        
//        URLSession.shared.dataTaskPublisher(for: url)
//                .map { $0.data }
//                .decode(type: GameDetail.self, decoder: JSONDecoder())
//                .receive(on: DispatchQueue.main)
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        print("Successfully fetched game detail.")
//                    case .failure(let error):
//                        print("Error decoding game detail: \(error)")
//                    }
//                }, receiveValue: { gameDetail in
//                    print("Game Detail: \(gameDetail)")
//                    completion(gameDetail)
//                })
//                .store(in: &cancellables)
//    }
    
    func fetchGameData(gamePK: Int) {
        let urlString = "https://statsapi.mlb.com/api/v1.1/game/\(gamePK)/feed/live"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data -> [String: Any] in
                // Parse the JSON into a dictionary
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    throw URLError(.badServerResponse)
                }
                return json
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching game data: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] json in
                self?.fangameData = json
                print("game data fected")
                // Extract allPlays from the JSON
                if let liveData = json["liveData"] as? [String: Any],
                   let plays = liveData["plays"] as? [String: Any],
                   let allPlaysArray = plays["allPlays"] as? [[String: Any]] {
                    self?.singleAllPlays = allPlaysArray
                   // print("game play data fected \(allPlaysArray)")
                    
//                    let playIds: [String] = allPlaysArray.compactMap { play in
//                        play["playId"] as? String
//                    }
                  
                  //  print("All Play IDs: \(playIds)")
                } else {
                    print("Error: Unable to extract allPlays from JSON")
                }
            })
            .store(in: &cancellables)
    }
    
    
    func loadSchedules() {
        guard let url = URL(string: "https://statsapi.mlb.com/api/v1/schedule?sportId=1&season=2024") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let schedule = try decoder.decode(Schedule.self, from: data)
                // print("got schedule of \(schedule.dates.count)")
                DispatchQueue.main.async {
                    self.seasonSchedule = schedule
                    
                    //print("returned shedule are \(self.seasonSchedule!.dates.count)")
                    // Optionally filter for the current selected day
                    self.filterGames(for: self.selectedDay)
                    
                    if !self.selectedFavourites.isEmpty {
                        self.loadOurNextGames(for: self.OurNextGameDay, teamNames: [self.selectedFavourites[0].name])
                    }
                 
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    
    // Filter the games for the selected day
    func filterGames(for date: Date) {
        guard let schedule = seasonSchedule else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Schedule uses this format
        
        let selectedDateString = formatter.string(from: date)
        
        filteredGames = schedule.dates
            .filter { $0.date == selectedDateString } // Match the selected date
            .flatMap { $0.games } // Extract all games for that day
        
        //print("filtered gaem \(filteredGames)")
    }
    
    func fetchTeamRoster(teamId: Int, completion: @escaping (Result<[Player], Error>) -> Void) {
        let url = "https://statsapi.mlb.com/api/v1/teams/\(teamId)/roster?season=2024"
         
        AF.request(url).responseDecodable(of: RosterResponse.self) { response in
            switch response.result {
            case .success(let rosterResponse):
                completion(.success(rosterResponse.roster))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
  
    func fetchFavorites() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                // Fetch data
                let data = try Data(contentsOf: self?.url ?? URL(fileURLWithPath: ""))
                
                // Parse NDJSON line by line
                guard let jsonString = String(data: data, encoding: .utf8) else { return }
                let lines = jsonString.split(separator: "\n")
                
                var favoriteCounts: [String: Int] = [:]
                
                for line in lines {
                    if let jsonData = line.data(using: .utf8),
                       let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                       let favoriteTeamId = jsonObject["favorite_team_id"] as? String {
                        favoriteCounts[favoriteTeamId, default: 0] += 1
                    }
                }
                
                // Sort and update the published variable
                let sortedFavorites = favoriteCounts.sorted(by: { $0.value > $1.value })
                DispatchQueue.main.async {
                    self?.teamFavorites = sortedFavorites.map { ($0.key, $0.value) }
                }
            } catch {
                print("Error fetching or parsing data: \(error)")
            }
        }
    }
    
    func getLineup(from roster: [Player]) -> [Player] {
        // Define the required positions for a lineup
        let requiredPositions = ["P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "DH"] // DH if applicable

        // Create a dictionary to keep track of the first player for each position
        var lineup: [Player] = []
        var addedPositions: Set<String> = []

        for player in roster {
            let positionAbbreviation = player.position.abbreviation
            if requiredPositions.contains(positionAbbreviation), !addedPositions.contains(positionAbbreviation) {
                lineup.append(player)
                addedPositions.insert(positionAbbreviation)
            }

            // Break the loop if all required positions are filled
            if addedPositions.count == requiredPositions.count {
                break
            }
        }

        return lineup
    }
    
    func loadOurNextGames(for from: Date, teamNames: [String]) {
        guard let schedule = seasonSchedule else {
            print("pass through")
            return
        }
        
        //print("pass through")
        // Calculate the end date (2 weeks from the provided date)
        let calendar = Calendar.current
        guard let endDate = calendar.date(byAdding: .day, value: 14, to: from) else { return }
        
        // Filter the games
        OurfilteredGames = schedule.dates
//            .filter { scheduleDate in
//                // Convert the schedule date string to a Date object
//                guard let gameDate = ISO8601DateFormatter().date(from: scheduleDate.date) else { return false }
//                
//                // Check if the gameDate falls within the 2-week window
//                return gameDate >= from && gameDate <= endDate
//            }
            .flatMap { scheduleDate in
                scheduleDate.games.filter { game in
                    // Check if the game involves any of the teams in the provided array
                    teamNames.contains { teamName in
                        game.teams.home.team.name == teamName || game.teams.away.team.name == teamName
                    }
                }
            }
        
       
    }
    
    func downsample(data: [Double], targetCount: Int) -> [Double] {
        guard targetCount > 0, data.count > targetCount else { return data }

        let bucketSize = Double(data.count) / Double(targetCount)
        var downsampledData: [Double] = []

        for i in 0..<targetCount {
            let start = Int(Double(i) * bucketSize)
            let end = Int(Double(i + 1) * bucketSize)
            let range = start..<min(end, data.count)
            let average = range.map { data[$0] }.reduce(0, +) / Double(range.count)
            downsampledData.append(average)
        }

        return downsampledData
    }
    
    func calculateOverallPerformancePercentage(scores: [Double]) -> Int {
        // Ensure the scores array has at least two elements and the first score isn't zero
        guard let firstScore = scores.first, let lastScore = scores.last, firstScore != 0 else {
            print("Invalid input: either no scores or division by zero")
            return 0
        }
        
        // Calculate the percentage change
        let overallPercentage = ((lastScore - firstScore) / firstScore) * 100
        return Int(overallPercentage)
    }

    
    func getTeamScoresData(teamID: Int) -> [Double] {
        guard let schedule = seasonSchedule else { return [] }
        
        // Filter games involving the given team
        let teamGames = schedule.dates
            .flatMap { $0.games }
            .filter { game in
            game.teams.home.team.id == teamID || game.teams.away.team.id == teamID
            //game.teams.home.team.id == teamID || game.teams.away.team.id == teamID
        }
        
        // Determine win/loss for each game
        let winLossRecord: [Double] = teamGames.map { game in
            if game.teams.home.team.id == teamID {
                // Home team: win if their score is higher
                return Double(game.teams.home.score ?? 0)
            } else {
                // Away team: win if their score is higher
                return Double(game.teams.away.score ?? 0)
            }
        }
        
        return winLossRecord
    }
    
    
    func restartView() {
        viewneedsRestart = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewneedsRestart = false
        }
    }
    
    func restartApp() {
        needsRestart = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.needsRestart = false
        }
    }
    
    func getTeamWinLossRecord(teamID: Int) -> [Bool] {
        guard let schedule = seasonSchedule else { return [] }
        
        // Filter games involving the given team
        let teamGames = schedule.dates
            .flatMap { $0.games }
            .filter { game in
            game.teams.home.team.id == teamID || game.teams.away.team.id == teamID
            //game.teams.home.team.id == teamID || game.teams.away.team.id == teamID
        }
        
        // Determine win/loss for each game
        let winLossRecord: [Bool] = teamGames.map { game in
            if game.teams.home.team.id == teamID {
                // Home team: win if their score is higher
                return (game.teams.home.score ?? 0) > (game.teams.away.score ?? 0)
            } else {
                // Away team: win if their score is higher
                return (game.teams.away.score ?? 0) > (game.teams.home.score ?? 0)
            }
        }
        
        return winLossRecord
    }
    
    func getLastFiveGames(for date: Date, teamId: Int) -> [Game] {
        // Flatten the schedule dates into a single list of games
        
        guard let schedule = seasonSchedule else { return [] }
        
        let FiveGames = schedule.dates
            .flatMap { $0.games }
            .filter { game in
                // Include games where the specified team is either the home or away team
                game.teams.home.team.id == teamId || game.teams.away.team.id == teamId
            }
            .prefix(5)
        
        // Filter games before the provided date
//        let pastGames = allGames.filter { game in
//            if let gameDate = ISO8601DateFormatter().date(from: game.gameDate) {
//                return gameDate < date
//            }
//            return false
//        }
        
        // Sort games by date in descending order and take the last 5
//        let lastFiveGames = pastGames.sorted { game1, game2 in
//            guard let date1 = ISO8601DateFormatter().date(from: game1.gameDate),
//                  let date2 = ISO8601DateFormatter().date(from: game2.gameDate) else {
//                return false
//            }
//            return date1 > date2
//        }.prefix(5)
        
        return Array(FiveGames)
    }
    
    func getGameTime(from gameDateString: String) -> String? {
        // Create a DateFormatter for parsing the date string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let gameDate = dateFormatter.date(from: gameDateString) {
            // Set the DateFormatter to show time in 12-hour format with AM/PM
            dateFormatter.dateFormat = "h:00a"
            return dateFormatter.string(from: gameDate)
        } else {
            return nil
        }
    }
    func fetchTeams() {
        let url = "https://statsapi.mlb.com/api/v1/teams?sportId=1"
        
        AF.request(url).responseDecodable(of: TeamsResponse.self) { response in
          //  print("\(response)")
            switch response.result {
            case .success(let result):
                self.teams = result.teams
            case .failure(let error):
                print("Error fetching teams: \(error)")
            }
        }
    }
    
    func fetchHomeRunData(completion: @escaping ([HomeRun]?) -> Void) {
        let urlString = "https://storage.googleapis.com/gcp-mlb-hackathon-2025/datasets/2024-mlb-homeruns.csv"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let csvString = String(data: data, encoding: .utf8) else {
                print("Failed to decode data")
                completion(nil)
                return
            }
            
            let rows = csvString.components(separatedBy: "\n")
            guard rows.count > 1 else {
                print("No data found in CSV")
                completion(nil)
                return
            }
            
            let headers = rows[0].components(separatedBy: ",") // Header row
            let dataRows = rows.dropFirst() // Data rows
            
            var homeRunDataArray: [HomeRun] = []
            
            for row in dataRows {
                let columns = row.components(separatedBy: ",")
                guard columns.count == headers.count else {
                    continue // Skip rows with incorrect column counts
                }
                
                // Parse the row into a `HomeRunData` object
                let play_id = String(columns[0])
                   let title = String(columns[1])
                   let ExitVelocity = Double(columns[2])
                   let HitDistance = Double(columns[3])
                   let LaunchAngle = Double(columns[4])
                    let video = String(columns[5])
                    let homeRunData = HomeRun(
                        play_id: play_id, title: title, ExitVelocity: ExitVelocity ?? 0.0, HitDistance: HitDistance ?? 0.0, LaunchAngle: LaunchAngle ?? 0.0, video: video
                    )
                    homeRunDataArray.append(homeRunData)
//
            }
//            DispatchQueue.main.async {
//                self.homeRunData = homeRunDataArray
//            }
            completion(homeRunDataArray)
        }.resume()
    }
    
    
    func fetchPlayerInfo(playerID: Int, completion: @escaping (Result<PlayerInfo, Error>) -> Void) {
        let url = "https://statsapi.mlb.com/api/v1/people/\(playerID)/"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: PlayerResponse.self) { response in
                switch response.result {
                case .success(let playerResponse):
                    if let player = playerResponse.people.first {
                        completion(.success(player))
                    } else {
                        completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Player not found."])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func startLiveActivity(homeTeam: String, awayTeam: String, stadium: String, homeImage: String, awayImage: String) {
        let initialContentState = GameAttributes.ContentState(homeScore: 8, awayScore: 12)

        let attributes = GameAttributes(
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            stadiumName: stadium,
            homeTeamImage: homeImage,
            awayTeamImage: awayImage
        )

        do {
            _ = try Activity<GameAttributes>.request(
                attributes: attributes,
                contentState: initialContentState,
                pushType: nil
            )
            print("Live Activity started!")
        } catch {
            print("Error starting Live Activity: \(error.localizedDescription)")
        }
    }
    
    
    // Populate the array with 20 comments
    var comments: [CommentStructure] {
        
        let comment1Id = UUID().uuidString
          let comment2Id = UUID().uuidString
          let comment3Id = UUID().uuidString
        return [CommentStructure(id: comment3Id, commentText: "That was an insane catch in center field!", commentPlayer: "Mike Trout", isReply: false, mainContentId: nil, commenterProfilePic: "profile1", username: "BaseballFan01", date: Date()),
        CommentStructure(id: comment2Id, commentText: "Unbelievable home run by Ohtani!", commentPlayer: "Shohei Ohtani", isReply: false, mainContentId: nil, commenterProfilePic: "profile2", username: "MLBEnthusiast", date: Date()),
        CommentStructure(id: UUID().uuidString, commentText: "Could have been a better pitch. Poor call by the pitcher.", commentPlayer: "Clayton Kershaw", isReply: false, mainContentId: nil, commenterProfilePic: "profile3", username: "PitchMaster", date: Date()),
        CommentStructure(id: UUID().uuidString, commentText: "Completely agree! The pitcher should've aimed lower.", commentPlayer: "Clayton Kershaw", isReply: true, mainContentId: comment1Id, commenterProfilePic: "profile4", username: "StrikeZoneGuru", date: Date()),
        CommentStructure(id: UUID().uuidString, commentText: "What a slide into home base. Great hustle!", commentPlayer: "Mookie Betts", isReply: false, mainContentId: nil, commenterProfilePic: "profile5", username: "PlayByPlay", date: Date()),
        CommentStructure(id: UUID().uuidString, commentText: "I think the umpire made a questionable call there.", commentPlayer: "Aaron Judge", isReply: false, mainContentId: nil, commenterProfilePic: "profile6", username: "NeutralFan", date: Date())
                ]
    }

}
