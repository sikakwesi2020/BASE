//
//  YouTubePlayerView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/14/25.
//

import SwiftUI
import YouTubePlayerKit
import YouTubeiOSPlayerHelper

struct YouTubePlayerView: View {
    @ObservedObject var youTubePlayer: YouTubePlayer

    var body: some View {
        YouTubePlayerKit.YouTubePlayerView(youTubePlayer) { state in
            switch state {
            
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error(_):
                Text(verbatim: "YouTube player couldn't be loaded")
            }
        }
        .frame(height: 300)
    }
}

//#Preview {
//    YouTubePlayerView(youTubePlayer: YouTubePlayer)
//}
