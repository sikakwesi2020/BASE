//
//  DisclosureLabel.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/12/25.
//

import SwiftUI

struct DisclosureLabel: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    @ObservedObject var transVM:TranslationViewModel
    @Binding var currentLanguage: String
    
    var Plays: [String: Any]
    var body: some View {
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
//                        (Text("#Play ").bold() + Text("\(description)"))
                        PlayTranslation(transVM: transVM, sourceText: "\(description)", sourceLanguage: .init(identifier: "en"), targetLanguage: .init(identifier: "\(currentLanguage)"))
                           // .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                        let homeTeam = viewModel.openSingleGameData?.teams.home.team.name ?? ""
                        let awayTeam = viewModel.openSingleGameData?.teams.away.team.name ?? ""
                        HStack {
                            ViewBuilder.smallBadge(String: "\(homeTeam) → \(homeScore)")
                            ViewBuilder.smallBadge(String: "\(awayTeam) → \(awayScore)")
                            Spacer()
                        }
                        HStack {
                            ViewBuilder.advancedBadge(String: "B → \(batterName)" , bgColor: Color.black)
                            ViewBuilder.advancedBadge(String: "P → \(pitcherName)", bgColor: Color.red)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DisclosureLabel(transVM: TranslationViewModel(), currentLanguage: .constant("en"), Plays: [:])
}
