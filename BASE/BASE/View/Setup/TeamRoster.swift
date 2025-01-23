//
//  TeamRoster.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/28/24.
//

import SwiftUI

struct TeamRoster: View {
    @ObservedObject var viewModel:TeamsViewModel
    let team: Team
    let columns: Int = 3 // Number of columns in the grid
    @State private var Roster: [Player] = []
    
     
    var body: some View {
        
        
        List {
            Section(header: Text("Follow your favourite stars")) {
                HStack {
                    ViewBuilder.localImage(name: team.teamName, width: 80, height: 80, circle: false, corners: 0)
                        .overlay(content: {
                            Image(systemName: "baseball.fill")
                                .font(.title2)
                                .background(Circle().fill(Color.white))
                                .vAlign(.bottom).hAlign(.trailing)
                            
                        })
                    VStack(alignment: .leading) {
                        (Text(team.name).bold() + Text(" @\(team.teamName)").font(.caption))
                           
                        HStack(spacing: 1) {
                            Image(systemName: "pin.fill")
                                .font(.caption)
                            Text(team.locationName)
                            
                            Image(systemName: "person.3.sequence.fill")
                                .font(.caption)
                                .padding(.leading)
                            Text("\(Roster.count) Players")
                        }.foregroundColor(.gray).font(.caption)
                        
                        HStack(spacing: 1) {
                            Image(systemName: "square.2.layers.3d.fill")
                                .font(.caption).foregroundColor(.gray)
                            Text(team.leagueName)
                                .font(.caption).foregroundColor(.gray)
                        }
                    }
                }
            }
            
            Section(header: Text("Team Roster"), footer: Text("Select Favorites to follow")) {
                ScrollView(.horizontal) {
                           LazyHStack(alignment: .top, spacing: 10) { // Use LazyHStack for performance
                               ForEach(0..<(Roster.count / columns + (Roster.count % columns == 0 ? 0 : 1)), id: \.self) { rowIndex in
                                   VStack(spacing: 10) {
                                       ForEach(0..<columns) { columnIndex in
                                           let itemIndex = rowIndex * columns + columnIndex
                                           if itemIndex < Roster.count {
                                               let selected = viewModel.favouritePlayers.contains { roster in
                                                   roster.player.person.id == Roster[itemIndex].person.id
//                                                   roster.person.id == Roster[itemIndex].person.id
                                               }
                                               ViewBuilder.playerRosterProfile(person: Roster[itemIndex].person, selected: selected, position: "")
                                                   .onTapGesture(perform: {
                                                       if let index = viewModel.favouritePlayers.firstIndex(where: { $0.player.person.id == Roster[itemIndex].person.id}) {
//                                                       if let index = viewModel.favouritePlayers.firstIndex(where: { $0.person.id == Roster[itemIndex].person.id}) {
                                                           viewModel.favouritePlayers.remove(at: index)
                                                       } else {
                                                           viewModel.favouritePlayers.append( PlayerProfile(player: Roster[itemIndex], team: team) )
                                                       }
                                                       
                                                   })
                                           } else {
                                               Color.clear
                                                   .frame(width: 100, height: 100)
                                           }
                                       }
                                   }
                               }
                           }
                           .padding()
                       }
            }
        }
        .listStyle(.grouped)
        .onAppear {
            viewModel.fetchTeamRoster(teamId: team.id) { result in
                switch result {
                case .success(let roster):
                    Roster = roster
                case .failure(let error):
                    print("Error fetching roster: \(error.localizedDescription)")
                }
            }
        }
    }
}
//
//#Preview {
//    FavouritePlayers(viewModel: TeamsViewModel())
//}
