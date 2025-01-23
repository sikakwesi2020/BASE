//
//  ScheduleCard.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/28/24.
//

import SwiftUI

struct ScheduleCard: View {
    
    @EnvironmentObject var viewModel:TeamsViewModel
    @Environment(\.colorScheme) var color
    
    let game: Game
    var body: some View {
        VStack {
            HStack {
                
                VStack {
                    Circle()
                        .fill(Color.gray.opacity(0.07))
                        .frame(width: 80, height: 80)
                        .overlay(content: {
                            
                            if let homeTweamName = viewModel.teams.first(where: {$0.name == game.teams.home.team.name}){
                                Image(homeTweamName.teamName)
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                
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
                                
                            Text("\(game.teams.home.score ?? 0)")
                                .font(.caption)
                        }
                    } else {
                        VStack {
                            Text(game.teams.home.team.name)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                            Text("\(game.teams.home.score ?? 0)")
                                .font(.caption)
                        }
                    }
                  
                       
                }
                .frame(width: 100)
                Spacer()
                
                VStack {
                    Text("\(viewModel.getGameTime(from: game.gameDate) ?? "7PM")")
                        .font(.system(size: 25, weight: .bold))
                    
                    Text("\(game.status.abstractGameState)")
                        .font(.caption)
                }
                Spacer()
                
                VStack {
                    Circle()
                        .fill(Color.gray.opacity(0.07))
                        .frame(width: 80, height: 80)
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
                            Text("\(game.teams.away.score ?? 0)")
                                .font(.caption)
                        }
                            
                    } else {
                        VStack {
                            Text(game.teams.away.team.name)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .frame(height: 20)
                            Text("\(game.teams.away.score ?? 0)")
                                .font(.caption)
                        }
                    }
                }
                .frame(width: 100)
                
              
            }
            Divider()
            HStack {
                Text( game.venue.name)
                    .font(.caption)
            }
        }
        .foregroundColor(.black)
        .onAppear {
            print(game)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TeamsViewModel())
    //ScheduleCard()
}
