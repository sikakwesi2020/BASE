//
//  GamePlayHelper.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/16/25.
//

import Foundation

class GamePlayHelper {
    
    
    
    func decodePlayEvents(from Plays: [String: Any]) {
  
            if let play = Plays as? [String: Any],
               let playEvents = play["playEvents"] as? [[String: Any]] {
                
                var playEventObjects: [PlayEvent] = [] // Array to hold parsed PlayEvent objects
                
                for playEventDict in playEvents {
                    // Manually parse data and create PlayEvent object
                    if let type = playEventDict["type"] as? String,
                       let index = playEventDict["index"] as? Int,
                       let startTime = playEventDict["startTime"] as? String,
                       let endTime = playEventDict["endTime"] as? String,
                       let isPitch = playEventDict["isPitch"] as? IsPitch,
                       let countDict = playEventDict["count"] as? [String: Any],
                       let balls = countDict["balls"] as? Int,
                       let outs = countDict["outs"] as? Int,
                       let strikes = countDict["strikes"] as? Int,
                       let detailsDict = playEventDict["details"] as? [String: Any],
                       let awayScore = detailsDict["awayScore"] as? Int,
                       let homeScore = detailsDict["homeScore"] as? Int,
                       let description = detailsDict["description"] as? String,
                       let event = detailsDict["event"] as? String,
                       let eventType = detailsDict["eventType"] as? String,
                       let hasReview = detailsDict["hasReview"] as? HasReview, // Adjust for mixed types
                       let isOut = detailsDict["isOut"] as? Int,
                       let isScoringPlay = detailsDict["isScoringPlay"] as? Int {
                        
                        // Optional data for Player
                        let player = (playEventDict["player"] as? [String: Any]).flatMap { playerDict -> GPlayer? in
                            if let id = playerDict["id"] as? Int,
                               let link = playerDict["link"] as? String {
                                return GPlayer(id: id, link: link)
                            }
                            return nil
                        }
                        
                        // Optional data for PitchData
                        let pitchData = (playEventDict["pitchData"] as? [String: Any]).flatMap { pitchDict -> PitchData? in
                            if let coordinates = pitchDict["coordinates"] as? [String: String],
                               let x = coordinates["x"],
                               let y = coordinates["y"],
                               let strikeZoneTop = pitchDict["strikeZoneTop"] as? String,
                               let strikeZoneBottom = pitchDict["strikeZoneBottom"] as? String {
                                return PitchData(breaks: [:], coordinates: Coordinates(x: x, y: y), strikeZoneBottom: strikeZoneBottom, strikeZoneTop: strikeZoneTop)
                            }
                            return nil
                        }
                        
                        // Optional data for HitData
                        let hitData = (playEventDict["hitData"] as? [String: Any]).flatMap { hitDict -> HitData? in
                            if let hitCoordinates = hitDict["coordinates"] as? [String: String],
                               let coordX = hitCoordinates["coordX"],
                               let coordY = hitCoordinates["coordY"],
                               let hardness = hitDict["hardness"] as? String,
                               let location = hitDict["location"] as? Int,
                               let trajectory = hitDict["trajectory"] as? String {
                                return HitData(coordinates: HitCoordinates(coordX: coordX, coordY: coordY), hardness: hardness, location: location, trajectory: trajectory)
                            }
                            return nil
                        }
                        
                        // Create a PlayEvent object
                        let playEvent = PlayEvent(
                            type: type,
                            index: index,
                            player: player,
                            startTime: startTime,
                            endTime: endTime,
                            isPitch: isPitch,
                            count: Count(balls: balls, outs: outs, strikes: strikes),
                            details: Details(
                                awayScore: awayScore,
                                homeScore: homeScore,
                                description: description,
                                event: event,
                                eventType: eventType,
                                hasReview: hasReview,
                                isOut: isOut,
                                isScoringPlay: isScoringPlay
                            ),
                            pitchData: pitchData,
                            hitData: hitData,
                            playId: playEventDict["playId"] as? String,
                            pitchNumber: playEventDict["pitchNumber"] as? Int
                        )
                        
                        // Append to results
                        playEventObjects.append(playEvent)
                    } else {
                        print("Failed to parse playEvent: \(playEventDict)")
                    }
                }
                
                // Print all successfully parsed PlayEvent objects
                print(playEventObjects)
            }
        }
    
}
