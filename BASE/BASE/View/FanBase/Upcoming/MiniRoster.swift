//
//  MiniRoster.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/10/25.
//

import SwiftUI

struct MiniRoster: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    @State private var LineUp: [Player] = []
    
    let teamId: Int
    let width: CGFloat
    let game: Game
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            if LineUp.isEmpty {
                ProgressView()
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("LINE UP ...")
                                .font(.system(size: 20, weight: .black))
                            Spacer()
                            Button("Close") {
                                show.toggle()
                            }
                            .bold()
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        
                        let columns: Int = 3
                        ScrollView(.horizontal) {
                            LazyHStack(alignment: .top, spacing: 10) { // Use LazyHStack for performance
                                ForEach(0..<(LineUp.count / columns + (LineUp.count % columns == 0 ? 0 : 1)), id: \.self) { rowIndex in
                                    VStack(spacing: 10) {
                                        ForEach(0..<columns) { columnIndex in
                                            let itemIndex = rowIndex * columns + columnIndex
                                            if itemIndex < LineUp.count {
                                                let selected = viewModel.favouritePlayers.contains { roster in
                                                    roster.player.person.id == LineUp[itemIndex].person.id
                                                }
                                                ViewBuilder.playerRosterProfile(person: LineUp[itemIndex].person, selected: selected, position: LineUp[itemIndex].position.abbreviation)
                                                
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
                        
                        HStack {
                            Spacer()
                            Button("Open Game Details") {
                                show.toggle()
                                viewModel.openSingleGameData = game
                                viewModel.openSingleGame = true
                            }
                            .buttonBorderShape(.capsule)
                            .buttonStyle(.bordered)
                            Spacer()
                        }
                    }
                 
                }
                
            }
        }
        .frame(width: width, height: 520)
        .background(Rectangle().fill(.thinMaterial))
            .onAppear {
                viewModel.fetchTeamRoster(teamId: teamId) { result in
                    switch result {
                    case .success(let roster):
                        LineUp = roster
                        LineUp = viewModel.getLineup(from: roster)
                        print("totsl is \(LineUp.count)")
                    case .failure(let error):
                        print("Error fetching roster: \(error.localizedDescription)")
                    }
                }
            }
    }
}

//#Preview {
//    MiniRoster(teamId: 113, width: 400, show: .constant(true), game: Game)
//        .environmentObject(TeamsViewModel())
//}
