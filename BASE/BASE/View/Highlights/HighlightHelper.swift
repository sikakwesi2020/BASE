//
//  HighlightHelper.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/14/25.
//

import Foundation 
import Alamofire

class HighlightHelper: ObservableObject {
    
    @Published var activeUrl: String = "https://www.youtube.com/watch?v=mgl_JgwAv7w"
    @Published var activeType: curretnState = .youtube
    @Published var playListResponses: [YouTubePlaylistResponse] = []
    @Published var PodCastResponses: [YouTubePlaylistResponse] = []
    @Published var GameOfTheWeekResponses: [YouTubePlaylistResponse] = []
    @Published var AllStarResponses: [YouTubePlaylistResponse] = []
    @Published var activePlayList: YouTubePlaylistResponse?
    
    @Published var apiKey: String = ""
    
    
//   Client ID= 224326112488-q0tu4uiehlf5vvkgqvvq7i2frtd3j431.apps.googleusercontent.com
    
    
    let allStar:[Playlist] = [
        Playlist(id: "PLL-lmlkrmJamFF2VlPPgQIpEDXRCxV-6Z", name: "2023 MLB All-Star Game"),
        Playlist(id: "PLL-lmlkrmJam2Ou2x13oqRR3Zy0xJHIMw", name: "2022 All-Star Game"),
        Playlist(id: "PLL-lmlkrmJamyT7c8keq8xrQAjw1Dbk6T", name: "Japan All-Star Series"),
        Playlist(id: "PLL-lmlkrmJamx-BQmWLBdosChjp7f1D4w", name: "2018 All-Star Game"),
        Playlist(id: "PLL-lmlkrmJakT9lJ-gXKZyq3D0WB8Aspn", name: "VR 360: 2018 MLB All-Starse"),
    ]

    let playList: [Playlist] = [
        Playlist(id: "PLL-lmlkrmJam1gL_8GKJAl5w3uK9L8O0P", name: "2024 Full Game"),
        Playlist(id: "PLL-lmlkrmJanmnvQnd6GBaLZqsXHiuLR6", name: "MLB Europe Play Stories"),
        Playlist(id: "PLL-lmlkrmJam0TD-oZBZx6UR25P_1zkYw", name: "MLB Office Hours"),
        Playlist(id: "PLL-lmlkrmJambC4W_nUXq0sVcIaa6dLCD", name: "Hidden Classics!"),
        Playlist(id: "PLL-lmlkrmJalV4d4NfYFktTD6KX-aplIq", name: "Hall of Fame")
    ]
    
    let podCastPlayList: [Playlist] = [
        Playlist(id: "PLL-lmlkrmJakM6UB1akg9Dy0vszMOUt2Q", name: "The 6-1-1 Podcast"),
        Playlist(id: "PLoqDIJHlyN3P5T7m9eVHpeGSyYHOPXEIr", name: "On Base With Mookie Betts | Full Episodes"),
        Playlist(id: "PLzkAU1rHRLKcF_dlBMPQfA18Qv-homgJY", name: "Abriendo el Podcast"),
        Playlist(id: "PL7Kd1yzNfOdnZgwc3yg8jShJTsp-OMR4P", name: "Locked On MLB Podcast"),
        Playlist(id: "PL6zqlqyORemLVWQ6JszxKjD4QDJhIugF_", name: "Fantasy Baseball Today full episodes"),
      
    ]
    let gameOfWk: [Playlist] = [
        Playlist(id: "PLL-lmlkrmJamdvGKPMnIQFWevex7LQAkX", name: "MLB Game of the Week (9/23)"),
        Playlist(id: "PLL-lmlkrmJakTnwC9N6hSFzBLGMEn8cma", name: "MLB Game of the Week (9/17)"),
        Playlist(id: "PLL-lmlkrmJan5mEB6-wAZ6meNNfYM-2Ke", name: "MLB Game of the Week (9/8)"),
        Playlist(id: "PLL-lmlkrmJamHkO1zC1YGeoPBAleHlsDR", name: "MLB Game of the Week Live on YouTube (9/2)"),
        Playlist(id: "PLL-lmlkrmJakBgifzSo1TvTn_dcQKHd9-", name: "MLB Game of the Week Live on YouTube (8/25)"),
        Playlist(id: "PLL-lmlkrmJansz9qT4vzoZ14I9RNLZVeP", name: "MLB Game of the Week Live on YouTube (8/17)"),
        Playlist(id: "PLL-lmlkrmJalTIDIngHwRGj3o0WEfR9lf", name: "MLB Game of the Week Live on YouTube (8/11)")
    ]
    
   
    func getPlaylistName(by id: String, in from:String) -> String? {
        if from == "podcast" {
            return podCastPlayList.first { $0.id == id }?.name
        } else if from == "playlist" {
            return playList.first { $0.id == id }?.name
        } else if from == "allstar" {
            return allStar.first { $0.id == id }?.name
        } else {
            return gameOfWk.first { $0.id == id }?.name
        }
      
    }
    
    func runAndCompute() {
        fetchPlayListVideos(to: "playlist", playList: playList)
        fetchPlayListVideos(to: "podcast", playList: podCastPlayList)
        fetchPlayListVideos(to: "potw", playList: gameOfWk)
        fetchPlayListVideos(to: "allstar", playList: allStar)
    }

    func fetchPlayListVideos(to:String, playList: [Playlist]) {
        let group = DispatchGroup() // To handle multiple API requests in parallel
        var allPlaylists: [YouTubePlaylistResponse] = []
        
        for playlistId in playList {
            group.enter() // Notify the group that a request is starting
            
            let url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistId.id)&key=\(apiKey)"
            
            guard let requestUrl = URL(string: url) else {
                group.leave()
                return
            }
            
            URLSession.shared.dataTask(with: requestUrl) { data, response, error in
                defer { group.leave() } // Notify the group when the request finishes
                
                guard let data = data, error == nil else { return }
                
                do {
                    let playlistResponse = try JSONDecoder().decode(YouTubePlaylistResponse.self, from: data)
                    allPlaylists.append(playlistResponse)
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
                
            }.resume()
        }
        
        group.notify(queue: .main) {
            if to == "podcast" {
                self.PodCastResponses = allPlaylists
            } else if to == "playlist" {
                self.playListResponses = allPlaylists // When all requests are done, update the state
                self.activePlayList = self.playListResponses.first!
            } else if to == "potw" {
                self.GameOfTheWeekResponses = allPlaylists
            } else if to == "allstar" {
                self.AllStarResponses = allPlaylists
            }
           
        }
    }
    
    
 
    
    // Fetch captions metadata using OAuth2
//    func fetchCaptions(videoId: String, accessToken: String, completion: @escaping (Result<[CaptionItem], Error>) -> Void) {
//        let captionsURL = "https://www.googleapis.com/youtube/v3/captions"
//        
//        let parameters: [String: Any] = [
//            "part": "snippet",
//            "videoId": videoId
//        ]
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(accessToken)"
//        ]
//        
//        AF.request(captionsURL, method: .get, parameters: parameters, headers: headers).responseDecodable(of: YouTubeCaptionsResponse.self) { response in
//            switch response.result {
//            case .success(let captionsResponse):
//                completion(.success(captionsResponse.items))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
 
//    func fetchCaptions(videoId: String) {
//        // Step 1: Fetch captions metadata
//        let metadataUrl = "https://www.googleapis.com/youtube/v3/captions?part=snippet&videoId=\(videoId)&key=\(apiKey)"
//        
//        AF.request(metadataUrl, method: .get).responseJSON { response in
//            switch response.result {
//            case .success(let json):
//                if let jsonDict = json as? [String: Any],
//                   let items = jsonDict["items"] as? [[String: Any]],
//                   let firstItem = items.first,
//                   let captionId = firstItem["id"] as? String {
//                    
//                    print("Caption ID: \(captionId)")
//                    
//                    // Step 2: Fetch caption content using the retrieved caption ID
//                    let captionsUrl = "https://www.googleapis.com/youtube/v3/captions?id=\(captionId)&tfmt=srt"
//                    
//                    AF.request(captionsUrl, method: .get).response { response in
//                        switch response.result {
//                        case .success(let data):
//                            if let data = data, let captions = String(data: data, encoding: .utf8) {
//                                print("Captions Content: \n\(captions)")
//                            } else {
//                                print("Failed to decode captions content.")
//                            }
//                        case .failure(let error):
//                            print("Error fetching captions content: \(error.localizedDescription)")
//                        }
//                    }
//                } else {
//                    print("Failed to parse caption metadata.")
//                }
//            case .failure(let error):
//                print("Error fetching captions metadata: \(error.localizedDescription)")
//            }
//        }
//    }
//
    
    // Download all captions using OAuth2
//    func downloadAllCaptions(captions: [CaptionItem], accessToken: String, completion: @escaping (Result<[DecodedCaption], Error>) -> Void) {
//        let group = DispatchGroup()
//        var decodedCaptions: [DecodedCaption] = []
//        var errors: [Error] = []
//
//        for caption in captions {
//            group.enter()
//
//            // Build URL to download caption
//            let downloadURL = "https://www.googleapis.com/youtube/v3/captions/\(caption.id)"
//            
//            let headers: HTTPHeaders = [
////                "Authorization": "Bearer \(self.temPToken)"
//                "Authorization": "Bearer \(accessToken)"
//            ]
//            
//            let parameters: [String: Any] = [
//                "tfmt": "srt" // Specify the format (e.g., SRT)
//            ]
//            
//            // Perform request
//            AF.request(downloadURL, method: .get, parameters: parameters, headers: headers).response { response in
//                defer { group.leave() }
//                
//                if let data = response.data, let content = String(data: data, encoding: .utf8) {
//                    // Append the decoded caption
//                    let decodedCaption = DecodedCaption(
//                        language: caption.snippet.language,
//                        name: caption.snippet.name ?? "N/A",
//                        content: content
//                    )
//                    decodedCaptions.append(decodedCaption)
//                } else if let error = response.error {
//                    // Collect errors
//                    errors.append(error)
//                }
//            }
//        }
//
//        // Completion handler when all requests are done
//        group.notify(queue: .main) {
//            if errors.isEmpty {
//                completion(.success(decodedCaptions))
//            } else {
//                completion(.failure(errors.first ?? NSError(domain: "Unknown Error", code: 1)))
//            }
//        }
//    }
//   
//    func downloadAllCaptions(captions: [CaptionItem], accessToken: String, completion: @escaping (Result<[DecodedCaption], Error>) -> Void) {
//        let group = DispatchGroup()
//        var decodedCaptions: [DecodedCaption] = []
//        var errors: [Error] = []
//
//        for caption in captions {
//            group.enter()
//
//            // Build URL to download caption
//            let downloadURL = "https://www.googleapis.com/youtube/v3/captions/\(caption.id)"
//            let parameters: [String: Any] = [
//                "key": apiKey,
//                "tfmt": "srt" // Specify the format (e.g., SRT)
//            ]
//            
//            // Perform request
//            AF.request(downloadURL, method: .get, parameters: parameters).response { response in
//                defer { group.leave() }
//                
//                if let data = response.data, let content = String(data: data, encoding: .utf8) {
//                    // Append the decoded caption
//                    let decodedCaption = DecodedCaption(
//                        language: caption.snippet.language,
//                        name: caption.snippet.name ?? "N/A",
//                        content: content
//                    )
//                    decodedCaptions.append(decodedCaption)
//                } else if let error = response.error {
//                    // Collect errors
//                    errors.append(error)
//                }
//            }
//        }
//
//        // Completion handler when all requests are done
//        group.notify(queue: .main) {
//            if errors.isEmpty {
//                completion(.success(decodedCaptions))
//            } else {
//                completion(.failure(errors.first ?? NSError(domain: "Unknown Error", code: 1)))
//            }
//        }
//    }
//
//   
    func fetchCaptions(videoId: String, completion: @escaping (Result<[CaptionItem], Error>) -> Void) {
        let captionsURL = "https://www.googleapis.com/youtube/v3/captions"
        
        let parameters: [String: Any] = [
            "part": "snippet",
            "videoId": videoId,
            "key": apiKey
        ]
        
        AF.request(captionsURL, method: .get, parameters: parameters).responseDecodable(of: YouTubeCaptionsResponse.self) { response in
            switch response.result {
            case .success(let captionsResponse):
                completion(.success(captionsResponse.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func timeAgo(from dateString: String) -> String? {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        
        let now = Date()
        let timeInterval = Int(now.timeIntervalSince(date))
        
        if timeInterval < 60 {
            return "\(timeInterval) second" + (timeInterval == 1 ? " ago" : "s ago")
        } else if timeInterval < 3600 {
            let minutes = timeInterval / 60
            return "\(minutes) minute" + (minutes == 1 ? " ago" : "s ago")
        } else if timeInterval < 86400 {
            let hours = timeInterval / 3600
            return "\(hours) hour" + (hours == 1 ? " ago" : "s ago")
        } else if timeInterval < 604800 {
            let days = timeInterval / 86400
            return "\(days) day" + (days == 1 ? " ago" : "s ago")
        } else if timeInterval < 2419200 {
            let weeks = timeInterval / 604800
            return "\(weeks) week" + (weeks == 1 ? " ago" : "s ago")
        } else if timeInterval < 31536000 {
            let months = timeInterval / 2419200
            return "\(months) month" + (months == 1 ? " ago" : "s ago")
        } else {
            let years = timeInterval / 31536000
            return "\(years) year" + (years == 1 ? " ago" : "s ago")
        }
    }
}
