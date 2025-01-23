//
//  PreviewPlayList.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/15/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PreviewPlayList: View {
    let playlist: [YouTubePlaylistResponse]
    @ObservedObject var helper: HighlightHelper
    @Binding var showPlaylist: Bool
    let from: String
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(playlist, id: \.etag) { eachPlayList in
                    ZStack {
                        VStack {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: 300, height: 170)
                                .cornerRadius(15)
                                .overlay(content: {
                                    WebImage(url: URL(string: "\(eachPlayList.items.first!.snippet.thumbnails.high.url)")) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Rectangle().foregroundColor(.gray)
                                    }
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFill()
                                    .frame(width: 300, height: 165)
                                    .cornerRadius(10)
                                    
                                })
                                .overlay(content: {
                                    HStack {
                                        Image(systemName: "list.bullet.rectangle")
                                        
                                        Text("\(eachPlayList.items.count) Video\(eachPlayList.items.count > 1 ? "s" : "")")
                                            .foregroundColor(.white)
                                            .bold()
                                    }
                                    .foregroundColor(.white)
                                    .background(
                                        Rectangle()
                                            .frame(width: 120, height: 40, alignment: .leading)
                                            .cornerRadius(10)
                                    )
                                    .vAlign(.bottom)
                                    .hAlign(.leading)
                                    .padding(20)
                                })
                            HStack {
                                let name = helper.getPlaylistName(by: eachPlayList.items.first!.snippet.playlistId, in: from)
                                Text("\(name ?? "PlayList")")
                                    .padding(.horizontal, 5)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .frame(width: 300, height: 15, alignment: .leading)
                                    .lineLimit(1)
                                    
                                Spacer()
                            }
                        }
                    }
                    .onTapGesture(perform: {
                        showPlaylist.toggle()
                        helper.activePlayList = eachPlayList
                    })
                   
                }
            }
            .padding(.horizontal)
        }
    }
}
#Preview {
    HighLights()
}
