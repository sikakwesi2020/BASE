//
//  LeagueStandings.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/12/25.
//

import SwiftUI
import MarkdownUI
import AlertToast


struct LeagueStandings: View {
    
    @EnvironmentObject var viewModel:TeamsViewModel
    @StateObject var standing = StandingsHelper()
    let standingCols = ["W", "L", "PCT", "GB"]
    
    
    @State private var statusReport: Bool = false
    @State private var statusReportSheet: Bool = false
    @State private var showToast: Bool = false
    
    
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
                        
                        (Text("LEAGUE ").foregroundColor(.red) + Text("STANDINGS"))
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                        
                        Text("MLB 2024 Season Standings and Records")
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
                let records = standing.teamStandings.flatMap { $0.teamRecords }
                    .sorted {
                        guard let rank1 = Int($0.leagueRank), let rank2 = Int($1.leagueRank) else {
                            return false
                        }
                        return rank1 < rank2
                    }
                GeometryReader { reader in
                    ScrollView {
                        HStack(spacing:0) {
                            VStack(alignment: .leading) {
                                Text("Rank")
                                    .fontWeight(.bold)
                                    .frame(width: 50, height: 30, alignment: .leading)
                                
                                Divider()
                                ForEach(records) { record in
                                    
                                    if let fullTeamData = viewModel.teams.first(where: {$0.id == record.team.id}) {
                                        HStack {
                                            Text("\(record.leagueRank)")
                                                .padding(.trailing, 5)
                                            Circle()
                                                .fill(Color.gray.opacity(0.07))
                                                .frame(width: 30, height: 30)
                                                .overlay(content: {
                                                    Image(fullTeamData.teamName)
                                                        .resizable()
                                                })
                                            
                                            Text(fullTeamData.abbreviation)
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .multilineTextAlignment(.leading)
                                                .padding(.trailing, 5)
                                            Spacer()
                                            Rectangle()
                                                .fill(Color.black.opacity(0.1))
                                                .frame(width: 1, height:46)
                                        }
                                        .frame(height: 30)
                                        
                                    }
                                    Divider()
                                }
                            }.frame(width: 110)
                            ScrollView(.horizontal, showsIndicators: true) {
                                VStack(alignment: .leading) {
                                    HStack(spacing:0) {
                                        Text("W")
                                            .fontWeight(.bold)
                                            .foregroundColor(.green)
                                            .frame(width: 70, height: 30, alignment: .center)
                                        Text("L")
                                            .fontWeight(.bold)
                                            .frame(width: 70, alignment: .center)
                                            .foregroundColor(.red)
                                        Text("PCT")
                                            .fontWeight(.bold)
                                            .frame(width: 70, alignment: .center)
                                        Text("GB")
                                            .fontWeight(.bold)
                                            .frame(width: 70, alignment: .center)
                                        Text("WCGB")
                                            .fontWeight(.bold)
                                            .frame(width: 70, alignment: .center)
                                        Text("STRK")
                                            .fontWeight(.bold)
                                            .frame(width: 70, alignment: .center)
                                        Text("RS")
                                            .fontWeight(.bold)
                                            .frame(width: 70, alignment: .center)
                                        Text("RA")
                                            .fontWeight(.bold)
                                            .frame(width: 70, alignment: .center)
                                    }
                                    //.padding(.bottom, 4)
                                    .frame(height: 20)
                                    // .background(Color.red)
                                    Divider()
                                    
                                    VStack {
                                        ForEach(records) { record in
                                            
                                            //Computed property to transform TeamRecord to TeamRecordSummary
                                            let recordSummary = standing.getTeamRecords(forTeamId: record.team.id)
                                            var teamRecordsSummary: [TeamRecordSummary] {
                                                recordSummary.map { record in
                                                    TeamRecordSummary(
                                                        wins: record.wins,
                                                        losses: record.losses,
                                                        pct: record.winningPercentage,
                                                        gamesBehind: record.gamesBack,
                                                        wildCardGamesBehind: record.wildCardGamesBack,
                                                        streak: record.streak.streakType == "wins" ? record.streak.streakNumber : -record.streak.streakNumber,
                                                        runsScored: record.runsScored,
                                                        runsAllowed: record.runsAllowed
                                                    )
                                                }
                                            }
                                            
                                            HStack(spacing: 0) {
                                                Rectext("\(teamRecordsSummary.first!.wins)", cat: "wins")
                                                Rectext("\(teamRecordsSummary.first!.losses)", cat: "losses")
                                                Rectext("\(teamRecordsSummary.first!.pct)", cat: "pct")
                                                Rectext("\(teamRecordsSummary.first!.gamesBehind)", cat: "gamesBehind")
                                                Rectext("\(teamRecordsSummary.first!.wildCardGamesBehind)", cat: "wildCardGamesBehind")
                                                Rectext("\(teamRecordsSummary.first!.streak)", cat: "streak")
                                                Rectext("\(teamRecordsSummary.first!.runsScored)", cat: "runsScored")
                                                Rectext("\(teamRecordsSummary.first!.runsAllowed)", cat: "runsAllowed")
                                                
                                            }
                                            .padding(.vertical, 4)
                                            .background(Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(8)
                                            
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                
                Button {
                    if !statusReport {
                        if standing.markdownReport.isEmpty {
                            
                            statusReport = true
                            let summary = standing.generateSummaryJsonString(from: records)
                            let langua = LocaleManager.shared.fetchLocale()
                            //print("language is \( langua)")
                            Task {
                                if let Report = await standing.runAnalytics(jsonSummary: summary ?? "", responseLanguage: "\(langua)" ) {
                                    DispatchQueue.main.async {
                                        standing.markdownReport = Report
                                        statusReportSheet.toggle()
                                    }
                                    
                                } else {
                                    statusReport = false
                                    showToast.toggle()
                                    print("Failed  to generae report")
                                }
                            }
                        } else {
                            statusReportSheet.toggle()
                        }
                    }
                } label: {
                    if statusReport {
                        HStack {
                           Text("Generating summary")
                            ProgressView()
                        }
                    } else {
                        
                     
                        Text(standing.markdownReport.isEmpty ? "Summary with Gemini" : "View Report")
                       
                        
                    }
                }
                .buttonStyle(.bordered)
                
                Divider()
            }
        }
        .toast(isPresenting: $showToast){

                    //Choose .hud to toast alert from the top of the screen
                    AlertToast(displayMode: .hud, type: .regular, title: "Error occured, Try again")
                    
          
                }
        .sheet(isPresented: $statusReportSheet, onDismiss: {statusReport = false}, content: {

            ScrollView {
                Markdown("\(standing.markdownReport)")
                    .padding()
            }
        })
        .onAppear {
            
            Task {
                await standing.runc()
            }
        }
    }
    
    
    @ViewBuilder
    func Rectext(_ text: String, cat: String) -> some View {
        Text("\( cat == "streak" && text.starts(with: "-") ? "\(text.replacingOccurrences(of: "-", with: ""))L" : text)")
            .fontWeight(.medium)
            .frame(width: 70, height: 30, alignment: .center)
            .if(cat == "wildCardGamesBehind" && text.starts(with: "+")) {
                $0.foregroundStyle(.green)
            }
            .if(cat == "streak" && text.starts(with: "-")) {
                $0.foregroundStyle(.red)
            }
            .overlay(content: {
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .frame(width: 1, height:100)
                    .hAlign(.trailing)
                
            })
        
    }
}

#Preview {
//    ContentView()
//        .environmentObject(TeamsViewModel())
        LeagueStandings()
        .environmentObject(TeamsViewModel())
}
