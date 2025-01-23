//
//  SinglePlayerInformation.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/11/25.
//

import SwiftUI
import Alamofire
struct SinglePlayerInformation: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:TeamsViewModel
    
    @State private var fullData:PlayerInfo?
    
    @Binding var teamName: String
    @Binding var playerData: Player?
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
                                Circle()
                                    .fill(Color.gray.opacity(1))
                                    .frame(width: 100, height: 100)
                                    .overlay(content:  {
                                        ViewBuilder.Profile(id: playerData?.person.id ?? 660271, height: 100)
                                            .cornerRadius(50)
                                    })
                            
                                VStack(alignment: .leading) {
                                    
                                    (Text("\(playerData?.person.fullName.capitalized ??  "Shohei Ohtani".capitalized) ").foregroundColor(.red))
                                        .foregroundColor(.white)
                                        .font(.system(size: 30, weight: .black))
                                    
                                    Text("\(fullData?.nickName ?? "Showtime")")
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                            }
                         
                            
                        }
                        .padding()
                        Image(teamName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .grayscale(0.9)
                            .opacity(0.3)
                            .padding()
                            .vAlign(.top)
                            .hAlign(.trailing)
                    }
                    .frame(height: 150)
                    
                    
                    if let player = fullData {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                              
                                // Player Basic Info
                                SectionView(title: "Basic Info") {
                                    InfoRow(label: "Birth Date", value: player.birthDate)
                                    InfoRow(label: "Age", value: "\(player.currentAge)")
                                    InfoRow(label: "Birthplace", value: "\(player.birthCity), \(player.birthCountry)")
                                    InfoRow(label: "Height", value: player.height)
                                    InfoRow(label: "Weight", value: "\(player.weight) lbs")
                                }

                                // Position Details
                                SectionView(title: "Position") {
                                    InfoRow(label: "Primary Position", value: player.primaryPosition.name)
                                    InfoRow(label: "Position Code", value: player.primaryPosition.code)
                                    InfoRow(label: "Abbreviation", value: player.primaryPosition.abbreviation)
                                }

                                // Player Stats
                                SectionView(title: "Stats") {
                                    InfoRow(label: "Bats", value: "\(player.batSide.description) (\(player.batSide.code))")
                                    InfoRow(label: "Throws", value: "\(player.pitchHand.description) (\(player.pitchHand.code))")
                                    if let mlbDebut = player.mlbDebutDate {
                                        InfoRow(label: "MLB Debut", value: mlbDebut)
                                    }
                                    InfoRow(label: "Strike Zone", value: "\(player.strikeZoneBottom)-\(player.strikeZoneTop) feet")
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        // Loading or Empty State
                        VStack {
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()
                            Text("Loading player information...")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                    }
                    
                }
            }
        }
        .onAppear {
            viewModel.fetchPlayerInfo(playerID: playerData?.person.id ?? 660271) { result in
                switch result {
                case .success(let player):
                    fullData = player
                case .failure(let error):
                    print("Error fetching player info: \(error.localizedDescription)")
                }
            }

       
        }
    }
    

}

#Preview {
    SinglePlayerInformation(teamName: .constant("Mets") , playerData: .constant(nil))
        .environmentObject(TeamsViewModel())
}
