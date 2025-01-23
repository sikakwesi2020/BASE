//
//  Home.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/24/24.
//

import SwiftUI
import SwiftUICharts
import UserNotifications


struct Home: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel:TeamsViewModel
    @StateObject private var ContentviewModel = FanContentViewModel()
    
    @State private var activeTab = "home"
    @State private var loadTeams:Bool = false
    @State private var openFulTeam:Bool = false
    
    @State private var activeTeam:Team?
    
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    
     
    var body: some View {
        
        let homeCards:[BaseCards] = [BaseCards(miniLeagueTitle: NSLocalizedString("Major League Baseball", comment: "") , title: NSLocalizedString("FanBase", comment: ""), minititle: NSLocalizedString("\(viewModel.selectedFavourites.count) Favouites", comment: ""), forgroundimage: "fans", icon: "baseball.diamond.bases", view: AnyView(FanBaseHomeView())), BaseCards(miniLeagueTitle: NSLocalizedString("Schedule", comment: ""), title: NSLocalizedString("Our Next Games", comment: ""), minititle: NSLocalizedString("\(viewModel.OurfilteredGames.count) upcoming", comment: ""), forgroundimage: "play-of-the-week", icon: "calendar", view: AnyView(FanBaseUpcomingGames()))]
        
        NavigationStack {
            GeometryReader { proxy in
                
                VStack(spacing: 0) {
                    
                    ZStack {
                        
                        Rectangle()
                            .fill(.clear)
                           // .cornerRadius(10, corners: [.])
                           // .ignoresSafeArea()
                            .frame(height: 70)
                        
                        HStack {
                            Image("mlb")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90)
                            
                            (Text("ML").foregroundColor(.red) + Text("BASE"))
                                .font(.system(size: 35, weight: .black))
                                
                            
                            Spacer()
                            
                            ViewBuilder.localImage(name: "player1", width: 40, height: 40, circle: false, corners: 0)
                        }
                        .padding(.horizontal)
                    }
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.selectedFavourites, id: \.id) { FavTeam in
                                        ViewBuilder.localImage(name: FavTeam.teamName, width: 65, height: 65, circle: true, corners: 0) {
                                            activeTeam = FavTeam
                                            openFulTeam.toggle()
                                        }
                                            .MlbOverlay(imageSize: 61)
                                    }
                                    
                                    ViewBuilder.newHightlight {
                                        loadTeams.toggle()
                                    }
                                }
                                .padding(2)
                                
                            }
                           
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        
                        VStack {
                            HStack {
                                HStack(spacing: 15) {
                                    Image(systemName: "figure.baseball")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.black)
                                        .frame(width: 50, height: 50)
                                        .background( activeTab == "home" ? Color.white.opacity(0.6) : Color.clear)
                                        .clipShape(Circle())
                                        .onTapGesture{
                                            withAnimation(.easeInOut){
                                                activeTab = "home"
                                            }
                                            
                                        }
                                    
                                    Image(systemName: "newspaper")
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        .font(.system(size: 20))
                                        .bold()
                                        .frame(width: 50, height: 50)
                                        .background( activeTab == "newspaper" ? Color.white.opacity(0.6) : Color.clear)
                                        .clipShape(Circle())
                                        .onTapGesture{
                                            withAnimation(.spring){
                                                activeTab = "newspaper"
                                            }
                                        }
                                    
                                    Image(systemName: "play.tv.fill")
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        .font(.system(size: 20))
                                        .frame(width: 50, height: 50)
                                        .background( activeTab == "highlight" ? Color.white.opacity(0.6) : Color.clear)
                                        .clipShape(Circle())
                                        .onTapGesture{
                                            withAnimation(.spring){
                                                activeTab = "highlight"
                                            }
                                        }
                                    
                                }
                                .padding(5)
                                .background(Color.red.gradient.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                Spacer()
                                Rectangle()
                                    .fill(Color.red.gradient.opacity(0.8))
                                    .frame(width: proxy.size.width - (285), height: 6)
                                    .cornerRadius(10)
                                
                                // Right profile image
                                Image(systemName: "baseball.fill")
                                    .font(.system(size: 40))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.red.gradient.opacity(0.8), lineWidth: 4)
                                    )
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                            .padding(.bottom, 5)
                            
                            
                            switch activeTab {
                            case "home" :
                               
                                    VStack(alignment: .leading) {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 15) {
                                                ForEach(homeCards, id: \.title) { card in
                                                    NavigationLink(destination: card.view) {
                                                        StatisticCards(ShortName:card.minititle , LongName: card.title, LeagueName:card.miniLeagueTitle , foreImage: card.forgroundimage, icon: card.icon)
                                                            .if(isIpad && homeCards.count == 1) {
                                                                $0.frame(width: UIScreen.main.bounds.width - 57, height: 300)
                                                            }
                                                            .if(isIpad && homeCards.count == 2) {
                                                                $0.frame(width: (UIScreen.main.bounds.width / 2) - 20, height: 300)
                                                            }
                                                            .if(isIpad && homeCards.count > 2) {
                                                                $0.frame(width: homeCards.count == 1 ? UIScreen.main.bounds.width - 20 :  UIScreen.main.bounds.width * 0.55, height: 300)
                                                            }
                                                            .if(!isIpad) {
                                                                $0.frame(width: homeCards.count == 1 ? UIScreen.main.bounds.width - 20 :  UIScreen.main.bounds.width * 0.70, height: 150)
                                                            }
                                                            .shadow(radius: 1)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    
                                case "highlight" :
                                ContentInteractions(viewModel: ContentviewModel, type: "videos")
                                    .padding(.horizontal, 10)
                                
                            case "newspaper":
                                ContentInteractions(viewModel: ContentviewModel, type: "article")
                                    .padding(.horizontal, 10)
                            default :
                                Text("")
                            }
                            
                            
                        }
                        // Play of the week
                        MiniHCards()
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.selectedFavourites, id: \.id) { FavTeam in
                                    
                                    let scores:[Double] = viewModel.getTeamScoresData(teamID: FavTeam.id)
                                    let downsampledScores = viewModel.downsample(data: scores, targetCount: 20)
                                    let rank = viewModel.calculateOverallPerformancePercentage(scores: scores)
                                    
                                    LineChartView(data: downsampledScores, title: FavTeam.teamName, legend: "Scores", style: Styles.lineChartStyleOne, rateValue: rank)
                                }
                            }
                            .padding()
                        }
                        .padding(.bottom)
//                        HStack {
//                            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "QStat", legend: "Mets", style: Styles.lineChartStyleOne)
//                            
//                            let chartStyle = ChartStyle(backgroundColor: Color.blue, accentColor: Color.red, secondGradientColor: Color.white, textColor: Color.white, legendTextColor: Color.white, dropShadowColor: Color.gray)
//                            
//                            let data = ChartData(points: [8,23,54,32,12,37,7,23,43])
//                            
//                            BarChartView(data: data, title: "Home Run", legend: "/ Game", style: chartStyle)
//                        }
                    }
                }
                
            }
            }
            .fullScreenCover(isPresented: $openFulTeam, content: {
                FullTeamPreview(team: $activeTeam)
            })
            .fullScreenCover(isPresented: $loadTeams, content: {
                TeamsSelectionView(showCancel: .constant(true))
            })
        }
        .onAppear {
          

            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied")
                }
            }
            viewModel.startLiveActivity(homeTeam: "New York Yankees", awayTeam: "", stadium: "Chase center", homeImage: "", awayImage: "")
            
            ContentviewModel.fetchFanContent()
        }
    }
}

#Preview {
    Home()
        .environmentObject(TeamsViewModel())
}


