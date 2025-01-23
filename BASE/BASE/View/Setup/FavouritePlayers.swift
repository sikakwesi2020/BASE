//
//  FavouritePlayers.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/28/24.
//

import SwiftUI

struct FavouritePlayers: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel:TeamsViewModel
    @State private var searchPlayers: String = ""
    
    let dismissHome: DismissAction
   
    @State private var selected = 0
    var body: some View {

//        NavigationView {
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
                        
                        (Text("FOLLOW ").foregroundColor(.red) + Text("PLAYERS"))
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                        
                        Text("Follow your favourite players and see their stats and performance")
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
                
                TabView(selection: $selected, content: {
                    
                    ForEach(Array(viewModel.selectedFavourites.enumerated()), id: \.element) { index, team in
                        
                        TeamRoster(viewModel: viewModel, team: team)
                            .tag(index)
                        
                    }
                })
                .tabViewStyle(.page)
            }
            .navigationBarBackButtonHidden(true)
                .navigationTitle("Follow players")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button {
                            dismissHome()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.red)
                        }
                    })
                    
                    ToolbarItem(placement: .bottomBar, content: {
                        HStack {
                            Button {
                                selected -= 1
                            } label: {
                                
                                if selected != 0 {
                                    // The next index exists
                                    let LastFavourite = viewModel.selectedFavourites[selected - 1]
                                    Text("\(LastFavourite.teamName) ← Prev ")
                                        .foregroundColor(selected == 0 ? .gray : .red)
                                    
                                    
                                } else {
                                    Text("Prev")
                                        .foregroundColor(selected == 0 ? .gray : .red)
                               }
                                
                               
                            }
                            .disabled(selected == 0)
                            Spacer()
                            Button {
                                if selected < viewModel.selectedFavourites.count - 1  {
                                    selected += 1
                                } else {
                                    dismissHome()
                                }
                            } label: {
                                if selected + 1 < viewModel.selectedFavourites.count {
                                    // The next index exists
                                    let nextFavourite = viewModel.selectedFavourites[selected + 1]
                                    Text("Next → \(nextFavourite.teamName)")
                                        .foregroundColor(selected < viewModel.selectedFavourites.count - 1 ? .red : .gray)
                                    
                                    
                                } else {
                                    Text(selected < viewModel.selectedFavourites.count - 1 ? "Next": "Done")
                                        .foregroundColor(.red)
                                        //.foregroundColor(selected < viewModel.selectedFavourites.count - 1 ? .red : .gray)
                                }
                              
                            }
                           // .disabled(selected == viewModel.selectedFavourites.count - 1)
                        }
                    })
                    
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button {
                            dismissHome()
                        } label: {
                            Text("Skip")
                                .foregroundColor(.red)
                        }
                    })
                }
                .navigationBarBackButtonHidden()
//        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TeamsViewModel())
}

