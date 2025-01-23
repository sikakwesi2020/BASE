//
//  PlayDisclosureView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/11/25.
//

import SwiftUI

struct PlayDisclosureView: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    var Plays: [String: Any]
    var body: some View {
        DisclosureGroup(content: {
            
            VStack {
                
                if let play = Plays as? [String: Any],
                   let playEvents = play["playEvents"] as? [[String: Any]] {
                        PlayEventTimelineView(playEvents: playEvents)

                }
            
                
            }
            
//                                HStack {
//                                    Button {
//                                        if let play = allPlays[index] as? [String: Any],
//                                            let playEvents = play["playEvents"] as? [[String: Any]] {
//                                            if let playId = playEvents.first!["playId"] as? String {
//
//                                            }
//
//                                            print(playEvents)
//                                            //let playIDs = extractPlayIDs(from: playEvents)
//                                               //print("Play IDs: \(playIDs)")
////                                            let vidUrl = "https://www.mlb.com/video/search?q=playid=\"\(play)\""
////                                            print(vidUrl)
//                                        }
//
//
//                                    } label: {
//
//                                        Image(systemName: "play.rectangle")
//                                            .font(.title2)
//                                            .bold()
//                                    }
                //.background(Rectangle().fill(Color.primary))
//                                }
        }, label: {
            VStack {
                HStack(alignment: .top) {
                    Rectangle()
                        .frame(width: 70, height: 140)
                        .cornerRadius(40)
                        .overlay(content: {
                           
                                VStack {
                                    if let play = Plays as? [String: Any],
                                       let matchup = play["matchup"] as? [String: Any],
                                       let batter = matchup["batter"] as? [String: Any],
                                       let pitcher = matchup["pitcher"] as? [String: Any],
                                       let batterID = batter["id"] as? Int,
                                       let pitcherID = pitcher["id"] as? Int {
                                        VStack {
                                            ViewBuilder.playerPlayProfile(id: batterID, type: "B", height: 65)
                                            Spacer()
                                            ViewBuilder.playerPlayProfile(id: pitcherID, type: "P", height: 65)
                                        }
                                    }
                                }
                                .padding(.vertical, 5)
//                                                }
                        })
                    
                    VStack(alignment: .leading) {
                        if let play = Plays as? [String: Any],
                           let matchup = play["matchup"] as? [String: Any],
                           let batter = matchup["batter"] as? [String: Any],
                           let pitcher = matchup["pitcher"] as? [String: Any],
                           let batterName = batter["fullName"] as? String,
                           let result = play["result"] as? [String: Any],
                           let event = result["event"] as? String,
                           let description = result["description"] as? String,
                           let awayScore = result["awayScore"] as? Int,
                           let homeScore = result["homeScore"] as? Int,
                           let pitcherName = pitcher["fullName"] as? String {
                            
                            
                            
                            
                            Text("@\(event)")
                                .bold().padding(.top, 5)
                            (Text("#Play ").bold() + Text("\(description)"))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                            let homeTeam = viewModel.openSingleGameData?.teams.home.team.name ?? ""
                            let awayTeam = viewModel.openSingleGameData?.teams.away.team.name ?? ""
                            HStack {
                                ViewBuilder.smallBadge(String: "\(homeTeam) → \(homeScore)")
                                ViewBuilder.smallBadge(String: "\(awayTeam) → \(awayScore)")
                                Spacer()
                            }
                            HStack {
                                ViewBuilder.advancedBadge(String: batterName, bgColor: Color.black)
                                ViewBuilder.advancedBadge(String: pitcherName, bgColor: Color.red)
                                Spacer()
                            }
                        }
                    }
                }
            }
            
        })
        .id(UUID())
    }
}

#Preview {
    PlayDisclosureView(Plays: [:])
        .environmentObject(TeamsViewModel())
}
