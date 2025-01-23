//
//  YoutubePlayerHelper.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/15/25.
//

import Foundation
import SwiftUI
import YouTubeiOSPlayerHelper

struct YouTubePlayerHelper: UIViewRepresentable {
    let videoID: String
    @Binding var currentTime: Double

    class Coordinator: NSObject, YTPlayerViewDelegate {
        var parent: YouTubePlayerHelper

        init(parent: YouTubePlayerHelper) {
            self.parent = parent
        }

        func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
            // Update the current playback time
            DispatchQueue.main.async {
                self.parent.currentTime = Double(playTime)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.delegate = context.coordinator
        playerView.load(withVideoId: videoID)
        return playerView
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) {}
}
//
//struct ContentView: View {
//    @State private var currentTime: Double = 0.0
//
//    var body: some View {
//        VStack {
//            Text("Current Time: \(currentTime, specifier: "%.2f") seconds")
//                .padding()
//
//            YouTubePlayerView(videoID: "dQw4w9WgXcQ", currentTime: $currentTime)
//                .frame(height: 300)
//        }
//        .padding()
//    }
//}
