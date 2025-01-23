//
//  SHRView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/4/25.
//

import SwiftUI
import AVFoundation
import UIKit
import _AVKit_SwiftUI


struct SHRView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:TeamsViewModel
    @State private var homeRun: [HomeRun] = []
    @State private var activeHomerun:HomeRun?
    @State private var activeTab: String = "Season"
    
    //  Active play
    @State private var playVideo: Bool = false
    @State private var playuRL: URL?
    @State private var playtitle: String = ""
    
    var body: some View {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: isIpad ? 4 : 2)
        let tabs = ["Season", "Recent", "Favorites", "Top Plays", "Longest Distance", "Player Highlights"]
        ZStack(alignment: .top) {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image("mlb")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    HStack {
                        
                        
                        (Text("HOME").foregroundColor(.red) + Text("RUN"))
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                        
                       
                    }
                    
                    Text("Enjoy fan favourite and most watched season home runs and runs from your favorite players")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .frame(height: 175)
                .background(Rectangle().fill(Color.black).ignoresSafeArea(edges: .top))
                
                ScrollView(.horizontal, showsIndicators: false ) {
                    HStack {
                        ForEach(tabs, id: \.self) { tab in
                            Text("\(tab)")
                                .font(.system(size: 15, weight: .black))
                               
                                .foregroundColor(activeTab == tab ? Color.red : Color.black)
                                .onTapGesture {
                                    withAnimation {
                                        activeTab = tab
                                    }
                                }
                            
                        }
                    }
                    .padding(.horizontal)
                }
                GeometryReader { reader in
                    let width = (reader.size.width - 15) / (isIpad ? 4 : 2)
                    
                    switch activeTab {
                    case "Season":
                        
                        ScrollView(.vertical) {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 5, content: {
                                ForEach(homeRun, id: \.play_id) { hr in
                                    eachHomeRunCard(play: hr, width: width, playVideo: $playVideo, playuRL: $playuRL, playtitle: $playtitle)
                                        .frame(width: width, height: 270)
                                        .cornerRadius(10)
                                    
                                }
                            })
                            .padding(.horizontal, 5)
                            
                        }
                    case "Recent" :
                        var randomHomeRuns: [HomeRun] {
                            return Array(homeRun.shuffled().prefix(30))
                        }
                        
                        ScrollView(.vertical) {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 5, content: {
                                ForEach(randomHomeRuns, id: \.play_id) { hr in
                                    eachHomeRunCard(play: hr, width: width, playVideo: $playVideo, playuRL: $playuRL, playtitle: $playtitle)
                                        .frame(width: width, height: 270)
                                        .cornerRadius(10)
                                }
                            })
                            .padding(.horizontal, 5)
                            
                        }
                    default:
                        var randomHomeRuns: [HomeRun] {
                            return Array(homeRun.shuffled().prefix(30))
                        }
                        
                        ScrollView(.vertical) {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 5, content: {
                                ForEach(randomHomeRuns, id: \.play_id) { hr in
                                    eachHomeRunCard(play: hr, width: width, playVideo: $playVideo, playuRL: $playuRL, playtitle: $playtitle)
                                        .frame(width: width, height: 270)
                                        .cornerRadius(10)
                                        .border(.white, width: 0.5)
                                }
                            })
                            .padding(.horizontal, 5)
                            
                        }
                    }
                    
                }
            }
            
            if playVideo {
                ZStack {
                    Rectangle()
                        .fill(Color.black)
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
            .onAppear {
                
                viewModel.fetchHomeRunData { homeRunData in
                    if let data = homeRunData {
                        homeRun = data
                    }
                }
            }
    }
}


struct eachHomeRunCard: View {
    let play: HomeRun
    let width: CGFloat
    
    @Binding var playVideo: Bool
    @Binding var playuRL: URL?
    @Binding var playtitle: String
    
    @State private var videoPreview: UIImage?
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
               // .shadow(radius: 5)
            
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
    SHRView()
        .environmentObject(TeamsViewModel())
}
