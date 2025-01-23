//
//  SingleGameView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/2/25.
//

import SwiftUI

struct SingleGameView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:TeamsViewModel
    @StateObject private var transVM = TranslationViewModel()
    @State private var activeTab: String = "All Plays"
    @State private var gameDetailJSON: [String: Any]?
    @State private var allPlays: [[String: Any]] = []
    @State private var expandedStates: [Int: Bool] = [:]
    
    
    @State private var currentLanguage: String = "en"
    @State private var viewId: UUID = UUID()

    
    let bottomNavs = ["All Plays", "Scored Plays"]
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black)
                    .ignoresSafeArea()
                
                let homeTeam = viewModel.openSingleGameData?.teams.home.team.name ?? "New York Mets"
                let awayTeam = viewModel.openSingleGameData?.teams.away.team.name ?? "Seatle Mariners"
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        let hometeamNam = viewModel.teams.first(where: {$0.name == homeTeam })
                        ViewBuilder.localImage(name: hometeamNam?.teamName ?? "Mets", width: 60, height: 60, circle: true, corners: 0)
                        VStack(alignment: .leading) {
                            Text(homeTeam).bold()
                            Text(hometeamNam?.teamName ?? "Mets").font(.caption)
                        }.foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(viewModel.openSingleGameData?.teams.home.score ?? 0)")
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        let awayteamNam = viewModel.teams.first(where: {$0.name == awayTeam })
                        ViewBuilder.localImage(name: awayteamNam?.teamName ?? "Mariners", width: 60, height: 60, circle: true, corners: 0)
                        VStack(alignment: .leading) {
                            Text(awayTeam).bold()
                            Text(awayteamNam?.teamName ?? "Mets").font(.caption)
                        }.foregroundColor(.white)
                        
                        Spacer()
                        Text("\(viewModel.openSingleGameData?.teams.away.score ?? 0)")
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.white)
                    }
                    
                    (Text("Game ").foregroundColor(.red) + Text("Analytics"))
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                    
                    Text("A comprehensive analysis of Major League Baseball games, covering player performance, team strategies, statistical trends, and game outcomes.")
                        .foregroundColor(.white)
                    // .lineLimit(2)
                }
                .padding()
                Image("mlb")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .grayscale(0.9)
                    .opacity(0.15)
                    .padding()
                    .padding(.top, 40)
                    .vAlign(.top)
                    .hAlign(.trailing)
            }
            .frame(height: 270)
            
            switch activeTab {
                
            case "All Plays":
                HStack {
                    Image(systemName: "baseball.fill")
                    Text("Play By Play")
                        .font(.system(size: 17, weight: .bold))
                    Spacer()
                    Menu {
                        ForEach(transVM.languageOptions, id: \.code) { language in
                            Button {
                                currentLanguage = language.code
                                viewId = UUID()
                            } label: {
                                
                                Label(language.name, systemImage: "list.clipboard")
                            }
                            
                        }
                    } label: {
                        HStack{
                            Image(systemName: "translate")
                            if let lang = transVM.languageOptions.first(where: { $0.code == currentLanguage }) {
                                Text(lang.name)
                                    .frame(width: 100, height: 30, alignment: .leading)
                                    .lineLimit(1)
                            } else {
                                Text("Translate")
                            }
                            
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color.black.gradient)
                        .cornerRadius(10)
                    }
                }.padding(.horizontal)
                
                
                ScrollView {
                    
                    LazyVStack(spacing: 10) {
                        ForEach(allPlays.indices, id: \.self) { index in
                            
                            CustomDisclosureGroup(isExpanded: Binding(
                                get: { expandedStates[index] ?? false },
                                set: { expandedStates[index] = $0 }
                            )) {
                                DisclosureLabel(transVM: transVM, currentLanguage: $currentLanguage, Plays: allPlays[index])
                            } content: {
                                EmptyView()
                              //  DisclosureContent(Plays: allPlays[index])
                            }
                        }
                    }
                    
                }
                .padding(.horizontal)
                .id(viewId)
                
            default:
                EmptyView()
            }
            
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(bottomNavs, id: \.self) { nav in
                        Button(nav) {
                            activeTab = nav
                        }
                        .if(nav == activeTab) {
                            $0.buttonStyle(.borderedProminent)
                        }
                        .if(nav != activeTab) {
                            $0.buttonStyle(.bordered)
                        }
                        
                    }
                }
                .padding()
            }
        }
        .onAppear {
            currentLanguage = LocaleManager.shared.fetchLocale().identifier
            
            viewModel.fetchSingleGameData(gamePK: viewModel.openSingleGameData?.gamePk ?? 748341) { result in
                switch result {
                case .success(let json):
                    gameDetailJSON = json
                    if let liveData = json["liveData"] as? [String: Any],
                       let playsData = liveData["plays"] as? [String: Any],
                       let allPlaysArray = playsData["allPlays"] as? [[String: Any]] {
                        
                        DispatchQueue.main.async {
                            self.allPlays = allPlaysArray
                        }
                        for index in allPlays.indices {
                            expandedStates[index] = false
                        }
                        
                    } else {
                        print("Error: Unable to extract 'allPlays' from JSON")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
            
        }
    }
    
    func extractPlayIDs(from playEvents: [[String: Any]]) -> [String] {
        var playIDs: [String] = []
        for event in playEvents {
            if let playId = event["playId"] as? String {
                playIDs.append(playId)
            }
        }
        return playIDs
    }
}

#Preview {
    SingleGameView()
        .environmentObject(TeamsViewModel())
}
