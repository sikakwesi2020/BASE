//
//  HighLights.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/14/25.
//

import SwiftUI
import YouTubePlayerKit
import SDWebImageSwiftUI

struct HighLights: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    @StateObject var helper = HighlightHelper()
    @State var youTubePlayer: YouTubePlayer = "https://www.youtube.com/watch?v=mgl_JgwAv7w"
    @State private var showPlaylist: Bool = false
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    Image("mlb")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    (Text("MLB ").foregroundStyle(.red) + Text("HighLights"))
                        .font(.title2)
                        .foregroundStyle(.black)
                        .fontWeight(.black)
                    Spacer()
                }
                .padding(.leading)
                ScrollView {
                    ZStack {
                        Rectangle()
                            .fill(Color.black).ignoresSafeArea()
                        
                        VStack {
                            Divider()
                            switch helper.activeType {
                                
                            case .youtube:
                                YouTubePlayerView(youTubePlayer: youTubePlayer)
                                
                            default:
                                EmptyView()
                            }
                     
                        }
                    }
                    
                    header(sf: "play.rectangle", name: "HighLights")
                  
                    PreviewPlayList(playlist: helper.playListResponses, helper: helper, showPlaylist: $showPlaylist, from: "playlist")
                    header(sf: "music.microphone", name: "PodCasts")
                   
                    
                    PreviewPlayList(playlist: helper.PodCastResponses, helper: helper, showPlaylist: $showPlaylist, from: "podcast")
                    
                    header(sf: "play.rectangle", name: "All-Star Game")
                    
                    PreviewPlayList(playlist: helper.AllStarResponses, helper: helper, showPlaylist: $showPlaylist, from: "allstar")
                    
                    header(sf: "baseball.fill", name: "Game of the week")
                    
                    
                    PreviewPlayList(playlist: helper.GameOfTheWeekResponses, helper: helper, showPlaylist: $showPlaylist, from: "gotwk")
                }
                
            }
            .fullScreenCover(isPresented: $showPlaylist, onDismiss: { helper.activePlayList = nil}, content: {
                ViewFullPlayList(helper: helper)
            })
            .onAppear {
                helper.apiKey = viewModel.YtApi
                helper.runAndCompute()
            }
            
        }
    }
    
    
    @ViewBuilder
    func header(sf: String, name: String)-> some View{
        HStack {
            Image(systemName: sf)
            Text(name)
              
            Spacer()
            
            Text("View All →")
                .foregroundColor(.red)
                .font(.caption)
                .padding(.trailing, 4)
        }
        .font(.title3)
        .fontWeight(.black)
        .foregroundColor(.black)
        .padding(.leading)
        .padding(.top)
    }
}

#Preview {
    HighLights()
}
