//
//  FanBaseHomeView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/1/25.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct FanBaseHomeView: View {
    
    @EnvironmentObject var viewModel:TeamsViewModel
    @State private var homeRun: [HomeRun] = []
    
    //  Active play
    @State private var playVideo: Bool = false
    @State private var playuRL: URL?
    @State private var playtitle: String = ""
    @State private var showPlayerDetals: Bool = false
    @State private var showFullFanStat: Bool = false
    @State private var activePlayerDetails: Player?
    @State private var activeTeam: String = ""
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
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
                        
                        (Text("MLB  ").foregroundColor(.red) + Text("FAN BASE"))
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                        
                        Text("The ultimate destination where fans unite to celebrate the game, relive every play, and share their passion for baseball.")
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .frame(height: 200)
                HStack {
                    Text("MY FAVORITES")
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                        .bold()
                        .padding(.trailing)
                }
                .padding(.leading, 9)
                .padding(.top, 5)
                VStack(alignment: .leading) {
                    
                    ForEach(viewModel.selectedFavourites, id: \.teamName) { team in
                        HStack {
                            Circle()
                                .fill(.thinMaterial)
                                .frame(width: 50)
                                .overlay(content: {
                                    Image(team.teamName)
                                        .resizable()
                                })
                            
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    let favstes = viewModel.favouritePlayers.filter({$0.team.id == team.id})
                                    ForEach(favstes, id: \.player.person.id) { fav in
                                        Circle()
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(width: 50)
                                            .overlay(content: {
                                                WebImage(url: URL(string: "https://securea.mlb.com/mlb/images/players/head_shot/\(fav.player.person.id).jpg")) { image in
                                                    image.resizable()
                                                } placeholder: {
                                                    Rectangle().foregroundColor(.gray)
                                                }
                                                .indicator(.activity) // Activity Indicator
                                                .transition(.fade(duration: 0.5))
                                                .scaledToFit()
                                                .cornerRadius(25)
                                                
                                            })
                                            .onTapGesture {
                                                activeTeam = team.teamName
                                                activePlayerDetails = fav.player
                                                showPlayerDetals.toggle()
                                            }
//                                            .popover(isPresented: $showPlayerDetals, content: {
//                                                SinglePlayerInformation(teamName: team.teamName , playerData: fav.player)
//                                                    .environmentObject(TeamsViewModel())
//                                            })
                                         
                                    }
                                    
                                    Circle()
                                        .fill(Color.black.gradient)
                                        .frame(width: 50)
                                        .overlay(content: {
                                            Image(systemName: "plus")
                                                .foregroundColor(.white)
                                                .bold()
                                        })
                                }
                            }
                            .padding(.leading, 5)
                            Spacer()
                        }
                        Divider()
                    }
                }
                .overlay(content: {
                    VStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1)
                            .hAlign(.leading)
                            .offset(x: 55)
                    }
                })
                .padding(5)
                .sheet(isPresented: $showPlayerDetals) {
                    SinglePlayerInformation(teamName: $activeTeam , playerData: $activePlayerDetails)
                       .environmentObject(TeamsViewModel())

                }
                HStack {
                    Text("FAN FAVORITES")
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                        .bold()
                        .padding(.trailing)
                        .onTapGesture {
                            showFullFanStat.toggle()
                        }
                }
                .padding(.leading, 9)
                .padding(.top, 15)
                if viewModel.teamFavorites.isEmpty {
                    HStack {
                        ProgressView()
                        Spacer()
                    }
                    .padding(.leading, 5)
                }
                VStack {
                    ForEach(viewModel.teamFavorites.prefix(5), id: \.teamId) { team in
                        HStack {
                            if let tName = viewModel.teams.first(where: {$0.id == Int(team.teamId) }) {
                                Text(" \(tName.teamName)")
                                    .font(.system(size: 14, weight: .bold))
                                    .frame(width: 70, alignment: .leading)
                            } else {
                                Text(" \(team.teamId)")
                                    .font(.system(size: 14, weight: .bold))
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
                
                HStack {
                    Text("MOST WATCHED")
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    Text("View All").foregroundStyle(.red).bold()
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                        .bold()
                        .padding(.trailing)
                }
                .padding(.leading, 5)
                .padding(.top)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        
                        var shuffledPlays: [[String: Any]] {
                            Array(viewModel.singleAllPlays.prefix(10))
                        }
                        
                        ForEach(Array(homeRun.shuffled().prefix(5)), id: \.play_id) { play in
                            ZStack {
                                Rectangle()
                                    .frame(width: 200, height: 300)
                                    .cornerRadius(10)
                                singlePlayVideoPreview(play: play, width: 200, playVideo: $playVideo, playuRL: $playuRL, playtitle: $playtitle)
                                
                            }
                            .frame(width: 200, height: 300)
                        }
                    }
                    .padding(.horizontal, 5)
                }
                
          
            }
            
            if playVideo {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                    
                    
                    
                    VideoPlayer(player: AVPlayer(url:  playuRL!))
                    
                        .frame(height: 400)
                    
                    Text("\(playtitle)")
                        .foregroundColor(.white)
                        .vAlign(.bottom)
                        .padding()
                    
                    Button {
                        playVideo = false
                        playuRL = nil
                        playtitle = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        
                            .padding()
                    }
                    .frame(width: 50, height: 50)
                    .vAlign(.topTrailing)
                    .hAlign(.trailing)
                }
            }
        }
        .sheet(isPresented: $showFullFanStat, content: {
            FanFavoriteChart()
               // .environmentObject(TeamsViewModel())
        })
        .onAppear {
       
                viewModel.fetchHomeRunData { homeRunData in
                    if let data = homeRunData {
                        homeRun = data
                    }
                }
            
            
        
           //viewModel.fetchFavorites()
            
            
        }
        
         
        
    }
}


struct singlePlayVideoPreview: View {
    let play: HomeRun
    let width: CGFloat
    
    @Binding var playVideo: Bool
    @Binding var playuRL: URL?
    @Binding var playtitle: String
    
    @State private var videoPreview: UIImage?
    var body: some View {
        ZStack {
            Rectangle().cornerRadius(10)
            
            if let prev = videoPreview {
                Image(uiImage: prev)
            } else {
                ProgressView()
                    .foregroundColor(.white)
            }
            
            Text("\(play.title)")
                .foregroundColor(.white)
                .font(.headline)
                .vAlign(.bottom)
                .hAlign(.leading)
                .padding(5)
            
            Text("\(Int.random(in: 1...10))k views")
                .font(.caption)
                .padding(5)
                .background(Color.white)
                .cornerRadius(5)
                .padding(5)
                .vAlign(.top)
                .hAlign(.trailing)
        }
        .onTapGesture {
            playuRL = URL(string: play.video)!
            playtitle = play.title
            playVideo = true
        }
        .onAppear {
            generateVideoPreview(url: URL(string: play.video)!)
        }
    }
    


    func generateVideoPreview(url: URL) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVAsset(url: url)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            assetImageGenerator.maximumSize = CGSize(width: width, height: 270) // Optimize resource usage
            
            let time = CMTime(seconds: 1.0, preferredTimescale: 600) // Capture frame at 1-second mark
            
            do {
                let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                
                DispatchQueue.main.async {
                    videoPreview = image
                }
            } catch {
                print("Error generating video preview: \(error.localizedDescription)")
                DispatchQueue.main.async {
                   
                }
            }
        }
    }
}

#Preview {
    FanBaseHomeView()
        .environmentObject(TeamsViewModel())
}
