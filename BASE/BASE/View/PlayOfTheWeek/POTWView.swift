//
//  POTWView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/2/25.
//

import SwiftUI
//import VideoPlayer
import CoreMedia
import AVFoundation
import _AVKit_SwiftUI


struct POTWView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:TeamsViewModel
    @StateObject private var videoModel = VideoPlayerViewModel()
    
    @State private var comment = ""
    @State private var play: Bool = true
    @State private var autoReplay: Bool = true
    @State private var mute: Bool = false
    @State private var time: CMTime = .zero
    @State private var totalvDuration: CMTime = .zero
       @State private var playProgress: CGFloat = 0.0
    let url = URL(string: "https://sporty-clips.mlb.com/TVpSTTVfWGw0TUFRPT1fQmdGV1VWUlhWMUFBWEZaVEJ3QUFWUTVYQUZoWFdsY0FWMTBEQndzREFGWUJCbGNF.mp4")!
    let width =  UIScreen.main.bounds.width
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
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
                        
                        (Text("TRENDING ").foregroundColor(.red) + Text("ON BASE"))
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                        
                        Text("Freddie Freeman homers (1) on a fly ball to center field. Shohei Ohtani scores.")
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
                .frame(height: 200)
                
             
                ScrollView {
                    VStack {
                        VideoPlayer(player: AVPlayer(url:  url))
                            .frame(height: 300)
                        
                        HStack {
                            Text("Fan Reactions")
                                .font(.system(size: 20, weight: .black))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.vertical) {
                            VStack(alignment: .leading, spacing: 30) {
                                ForEach(viewModel.comments, id: \.commentPlayer) { comment in
                                    if !comment.isReply {
                                        CommentView(comment: comment, isReply: false)
                                    }
                                    
                                    // Show replies for this comment
                                    ForEach(viewModel.comments.filter { $0.isReply && $0.mainContentId == comment.id }) { reply in
                                        CommentView(comment: reply, isReply: true)
                                    }
                                }
                            }
                            .padding()
                        }
                        
                    }
                }
                HStack {
                    Image("player1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(Circle().fill(Color.white))
                    
                    HStack {
                        TextField("Comment..", text: $comment)
                            .padding()
                        Button {
                            
                        } label: {
                            Image(systemName: "paperplane")
                                .padding(.trailing)
                        }
                    }
                    .background (
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.gray.gradient, lineWidth: 1)
                            .frame(height: 40)
                    )
                    
                }
                .padding()
                .background (
                    Rectangle()
                        .fill(.thinMaterial)
                        .ignoresSafeArea(edges: .bottom)
                    //.frame(height: 40)
                )
                .ignoresSafeArea(edges:.bottom)
                
                
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button("Done") {
                        dismiss()
                    }
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("12.3k watching...") {
                       
                    }
                })
            })
        }
    }

    
}

#Preview {
    POTWView()
        .environmentObject(TeamsViewModel())
}
