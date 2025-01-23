//
//  FanFavoriteChart.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/11/25.
//

import SwiftUI

struct FanFavoriteChart: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                            
                            (Text("FAN ").foregroundColor(.red) + Text("FAVOURITES"))
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .bold))
                            
                            Text("Track which teams fan are most passionate about, follow them and see their latest news and updates")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    .frame(height: 170)
                    ScrollView {
                    ForEach(viewModel.teamFavorites, id: \.teamId) { team in
                        HStack {
                            if let tName = viewModel.teams.first(where: {$0.id == Int(team.teamId) }) {
                                Text(" \(tName.teamName)")
                                    .font(.system(size: 12, weight: .bold))
                                    .frame(width: 70, alignment: .leading)
                            } else {
                                Text(" \(team.teamId)")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            
                            let maxLength = UIScreen.main.bounds.width - 150
                            let maxFavorites = viewModel.teamFavorites.first?.numFavorites ?? 1 // Avoid division by 0
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: CGFloat(team.numFavorites) / CGFloat(maxFavorites) * maxLength, height: 20)
                            Text("\(team.numFavorites)")
                                .font(.system(size: 10))
                                .padding(.leading, 8)
                            
                            
                            Spacer()
                        }
                        .padding(.leading, 5)
                    }
                }
                }
            }
            }
    }
}

#Preview {
    FanFavoriteChart()
        .environmentObject(TeamsViewModel())
}
