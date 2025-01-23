//
//  FanBaseUpcomingGames.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/1/25.
//

import SwiftUI
import SwiftUIPresent

struct FanBaseUpcomingGames: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    @Environment(\.colorScheme) var color
    @State private var ourGames:Schedule?
    @State private var openSingleGame = false
    
    
    @State private var selectedInvitationTab = 0
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            VStack {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Color.black)
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image("mlb")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            
                            
                            Spacer()
                        }
                        
                        (Text("OUR ").foregroundColor(.red) + Text("Games"))
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                        
                        Text("Catch all your upcoming and past games here")
                            .foregroundColor(.white)
                            .lineLimit(2)
                    }
                    .padding()
                    Image(systemName: "baseball")
                        .font(.system(size: 70, weight: .bold))
                        .opacity(0.2)
                        .padding()
                        .vAlign(.top)
                        .foregroundStyle(.white)
                        .hAlign(.trailing)
                }
                .frame(height: 150)
                ScrollView {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(viewModel.selectedFavourites.enumerated()), id: \.element) { i, data in
                                HStack {
                                    Image(data.teamName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                    Text("\(data.name)")
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedInvitationTab == i ? Color.blue : Color.clear)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.gray, lineWidth: selectedInvitationTab == i ? 0 : 1)
                                                )
                                        )
                                        .foregroundColor(selectedInvitationTab == i ? .white : color == .dark ? .white : .black)
                                        .onTapGesture {
                                            selectedInvitationTab = i
                                            viewModel.loadOurNextGames(for: viewModel.selectedDay, teamNames: [viewModel.selectedFavourites[i].name])
                                        }
                                }
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                
                                ForEach(viewModel.OurfilteredGames, id: \.gamePk) { game in
                                    AdvancedScheduleCard(game: game)
                                        .id(UUID())
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .safeAreaPadding(.horizontal, 10)
                        .navigationDestination(isPresented: $viewModel.openSingleGame, destination: {SingleGameView()})
                        
                        
                        
                        HStack {
                            Text("PREVIOUS GAMES")
                                .fontWeight(.black)
                                .font(.title3)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.leading)
                        
                        let lastFiveGames: [Game] = viewModel.getLastFiveGames(for: viewModel.selectedDay, teamId: viewModel.selectedFavourites[selectedInvitationTab].id)
                        VStack(spacing: 5) {
                            ForEach(lastFiveGames.prefix(3), id: \.gamePk) { game in
                                PastGameCard(game: game)
                                    .background(content: {
                                        Rectangle()
                                            .fill(Color.white)
                                            .cornerRadius(5)
                                    })
                                    .padding(5)
                            }
                        }
                       
                        
                    }
                }
            }
            .onAppear {
                viewModel.loadSchedules()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    viewModel.loadOurNextGames(for: viewModel.selectedDay, teamNames: [viewModel.selectedFavourites[selectedInvitationTab].name])
                }
            }
        }
    }
}





#Preview {
    ContentView()
//    FanBaseUpcomingGames()
        .environmentObject(TeamsViewModel())
}
