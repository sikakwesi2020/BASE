//
//  FullTeamPreview.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/11/25.
//

import SwiftUI
import SwiftUIPresent

struct FullTeamPreview: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:TeamsViewModel
    
    @State private var showIndividual: Bool = false
    @State private var activePlayerDetails: Player?
    @State private var Roster: [Player] = []
    @State private var winLossStat:[Bool] = []
    
    
    let columns = 3
    @Binding var team:Team?
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
                                ViewBuilder.localImage(name: team?.teamName ?? "Mets", width: 80, height: 80, circle: true, corners: 0)
                                
                                
                                Spacer()
                            }
                            
                            (Text("\(team?.name.capitalized ?? "Los Angeles Dodgers".capitalized) ").foregroundColor(.red))
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .bold))
                            
                            Text("\(team?.teamName ?? "Mets")")
                                .foregroundColor(.white)
                                .lineLimit(2)
                        }
                        .padding()
                        Image("mlb")
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
                    .padding(.top)
                    
                    ScrollView {
                        VStack {
                            ScrollView(.horizontal) {
                                HStack {
                                    miniScrollDetail(title: "\(team?.leagueName ?? "American League")", icon: "baseball")
                                    miniScrollDetail(title: "\(team?.locationName ?? "Flushing")", icon: "mappin.and.ellipse")
                                    miniScrollDetail(title: "\(team?.abbreviation ?? "Abbr")", icon: "character.circle.fill")
                                    miniScrollDetail(title: "\(team?.id ?? 1231)", icon: "numbersign")
                                    
                                }
                                .padding(5)
                            }
                            
                            HStack {
                                Text("Roster")
                                    .font(.system(size: 30, weight: .black))
                                Spacer()
                            }
                            .padding(.horizontal)
                               
                            ScrollView(.horizontal) {
                                       LazyHStack(alignment: .top, spacing: 10) {
                                           ForEach(0..<(Roster.count / columns + (Roster.count % columns == 0 ? 0 : 1)), id: \.self) { rowIndex in
                                               VStack(spacing: 10) {
                                                   ForEach(0..<columns) { columnIndex in
                                                       let itemIndex = rowIndex * columns + columnIndex
                                                       if itemIndex < Roster.count {
                                                           let selected = false
                                                           ViewBuilder.playerRosterProfile(person: Roster[itemIndex].person, selected: selected, position: "")
                                                               .onTapGesture(perform: {
                                                                       activePlayerDetails = Roster[itemIndex]
                                                                       showIndividual.toggle()
                                                                      
                                                               })
                                                       } else {
                                                           Color.clear
                                                               .frame(width: 100, height: 100)
                                                       }
                                                   }
                                               }
                                           }
                                       }
                                   }
                            
                            Divider()
                            HStack {
                                Text("GAME RECORD")
                                    .font(.headline)
                                    .fontWeight(.black)
                                Spacer()
                            }
                            .padding(.leading)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(winLossStat, id: \.self) { rec in
                                        record(label: rec ? "W" : "L")
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    
                }
                
            }
            .sheet(isPresented: $showIndividual) {
                
                SinglePlayerInformation(teamName: .constant(team?.teamName ?? "Mets"), playerData: $activePlayerDetails)
                    .environmentObject(TeamsViewModel())
            }
            
            .onAppear {
                viewModel.fetchTeamRoster(teamId: team?.id ?? 133) { result in
                    switch result {
                    case .success(let roster):
                        Roster = roster
                        
                        winLossStat = viewModel.getTeamWinLossRecord(teamID: team?.id ?? 133)
                       // print(winLossStat)
                      
                    case .failure(let error):
                        print("Error fetching roster: \(error.localizedDescription)")
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("Done") {
                        dismiss()
                    }
                })
            })
        }
    }
    
    
    
    @ViewBuilder
    
    func record(label: String)-> some View {
        Circle()
        
            .fill(label == "W" ? Color.green : Color.red)
            .frame(width: 60, height: 60, alignment: .center)
            .overlay(content: {
                Text(label)
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .black))
            })
    }
    
    func miniScrollDetail(title: String, icon: String) -> some View {
        
        HStack {
            Image(systemName: icon)
            Text(title)
              
            Spacer()
        }
        .foregroundColor(.white)
        .bold()
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.blue)
        .cornerRadius(20)
    }
    
    
}

#Preview {
    FullTeamPreview(team: .constant(nil))
        .environmentObject(TeamsViewModel())
}
