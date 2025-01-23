//
//  AdvancedScheduleCard.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/10/25.
//

import SwiftUI

struct AdvancedScheduleCard: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    @Environment(\.colorScheme) var color
    
    @State private var isawayPresented:Bool = false
    @State private var ishomePresented:Bool = false
    let game: Game
    let width =  UIScreen.main.bounds.width * 0.90
    var body: some View {
        
        let homeTweamName = viewModel.teams.first(where: {$0.name == game.teams.home.team.name})
        let awayTweamName = viewModel.teams.first(where: {$0.name == game.teams.away.team.name})
        ZStack {
            Image("play-of-the-week")
                .resizable()
                .scaleEffect(1.5)
                .blur(radius: 30)
                .cornerRadius(14)
                .frame(width: width, height: 250)
                .opacity(0.7)
            VStack {
                HStack {
                    VStack(alignment: .center) {
                        ViewBuilder.localImage(name: homeTweamName?.teamName ?? game.teams.home.team.name, width: 65, height: 65, circle: true, corners: 0)
                            .MlbOverlay(imageSize: 61)
                            .overlay(content: {
                                Image("player1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55)
                                    .clipShape(Circle())
                                    .vAlign(.top)
                                    .hAlign(.trailing)
                                    .offset(x: 20, y: -10)
                            })
                            .background(Circle().fill(Color.white))
                        
                        Text(homeTweamName?.teamName ?? game.teams.home.team.name)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .font(.caption)
                            .frame(width: 95,height: 40)
                    }
                    .onTapGesture {
                        ishomePresented.toggle()
                    }
                    .present(isPresented: $ishomePresented, style: .fade) {
                        MiniRoster(teamId: homeTweamName?.id ?? 0, width: width, game: game, show: $ishomePresented)
                            .id(UUID())
                            .environmentObject(TeamsViewModel())
                    }
                     
                    Spacer()
                    VStack {
                        Text("VS")
                            .bold()
                            .foregroundColor(.black)
                            .font(.title)
                            .fontWeight(.thin)
                        Text("Yankee Stadium")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .onTapGesture {
                        viewModel.openSingleGameData = game
                        viewModel.openSingleGame = true
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        ViewBuilder.localImage(name: awayTweamName?.teamName ?? game.teams.away.team.name , width: 65, height: 65, circle: true, corners: 0)
                            .MlbOverlay(imageSize: 61)
                            .overlay(content: {
                                Image("player1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55)
                                    .clipShape(Circle())
                                    .vAlign(.top)
                                    .hAlign(.leading)
                                    .offset(x: -20, y: -10)
                            })
                            .background(Circle().fill(Color.white))
                        Text(awayTweamName?.teamName ?? game.teams.away.team.name)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .font(.caption)
                            .frame(width: 95,height: 40)
                    }
                    .onTapGesture {
                        isawayPresented.toggle()
                    }
                    .present(isPresented: $isawayPresented, style: .fade) {
                        MiniRoster(teamId: awayTweamName?.id ?? 0, width: width, game: game, show: $isawayPresented)
                            .id(UUID())
                            .environmentObject(TeamsViewModel())
                    }
                     
                }
                .padding()
                
                
                
                HStack(spacing: 20) {
                    Image(systemName: "star")
                    Image(systemName: "heart")
                    Spacer()
                    Button {
                        viewModel.openSingleGameData = game
                        viewModel.openSingleGameTab = "messaging"
                        viewModel.openSingleGame = true
                    } label: {
                        HStack {
                            Image(systemName: "text.bubble")
                              
                        }
                    }
                  
                }
                .padding(.horizontal)
                .frame(width: width - 40 , height: 40)
                .background(Rectangle().fill(.thinMaterial).frame(height: 40))
                .cornerRadius(10)
                .customBadge(12)
                
            }
        }
        .frame(width: width, height: 250)
        .shadow(color: color == .dark ? .white : .black, radius: 0.5)
    }
}
 
