//
//  PastGameCard.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/3/25.
//

import SwiftUI

struct PastGameCard: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    let game: Game
    
    var body: some View {
        HStack {
            VStack {
                Circle()
                    .fill(Color.gray.opacity(0.07))
                    .frame(width: 60, height: 60)
                    .overlay(content: {
                        
                        if let homeTweamName = viewModel.teams.first(where: {$0.name == game.teams.home.team.name}) {
                            Image(homeTweamName.teamName)
                                .resizable()
                                .scaledToFit()
                        }
                    })
                    .overlay(content: {
                        
                        if game.teams.home.isWinner == true {
                            ViewBuilder.smallBadge(String: "Winner")
                                .font(.title2)
                                .foregroundColor(.red)
                                .background(Circle().fill(Color.white))
                                .vAlign(.top)
                                .hAlign(.trailing)
                               
                        }
                        
                    })
                if let homeTweamName = viewModel.teams.first(where: {$0.name == game.teams.home.team.name}){
                    VStack {
                        Text(homeTweamName.teamName)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    VStack {
                        Text(game.teams.home.team.name)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                }
              
                   
            }
            .padding(.vertical)
            .frame(width: 100)
            Spacer()
            HStack {
                Text("\(game.teams.home.score ?? 0)").fontWeight(.black)
                Text("Final").font(.caption)
                Text("\(game.teams.away.score ?? 0)").fontWeight(.black)
            }
            .font(.title)
            .fontWeight(.medium)
            Spacer()
            VStack {
                Circle()
                    .fill(Color.gray.opacity(0.07))
                    .frame(width:60, height: 60)
                    .overlay(content: {
                        if let homeTweamName = viewModel.teams.first(where: {$0.name == game.teams.away.team.name}){
                            Image(homeTweamName.teamName)
                                .resizable()
                                .scaledToFit()
//                                    .frame(width: 80, height: 80)
                        } else {
                            Image(game.teams.away.team.name)
                                .resizable()
                                .scaledToFit()
                        }
                    })
                    .overlay(content: {
                        
                        if game.teams.away.isWinner == true {
                            ViewBuilder.smallBadge(String: "Winner")
                                .font(.title2)
                                .foregroundColor(.red)
                                .background(Circle().fill(Color.white))
                                .vAlign(.top)
                                .hAlign(.trailing)
                               
                        }
                        
                    })
                    
                if let homeTweamName = viewModel.teams.first(where: {$0.name == game.teams.away.team.name}){
                    VStack {
                        Text(homeTweamName.teamName)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                        
                } else {
                    VStack {
                        Text(game.teams.away.team.name)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .frame(height: 20)
                    }
                }
            }
            .padding(.vertical)
            .frame(width: 100)
        }.padding(.horizontal)
            .onTapGesture {
                viewModel.openSingleGameData = game
                viewModel.openSingleGame = true
            }
    }
}

#Preview {
   // PastGameCard()
    ContentView()
        .environmentObject(TeamsViewModel())
}
