//
//  VideoPlayerViewModel.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/2/25.
//

import Foundation
import SwiftUI
import AVKit

class VideoPlayerViewModel: ObservableObject {
    @Published var currentTime: CMTime = .zero
    @Published var totalDuration: CMTime = .zero
    
    var player: AVPlayer?
    private var timeObserver: Any?

    func setupPlayer(url: URL) {
        player = AVPlayer(url: url)
        totalDuration = player?.currentItem?.asset.duration ?? .zero
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak self] time in
            self?.currentTime = time
        }
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}

struct CustomVideoPlayer: UIViewRepresentable {
    @ObservedObject var viewModel: VideoPlayerViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        context.coordinator.playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(context.coordinator.playerLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.playerLayer.frame = uiView.bounds
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator {
        let playerLayer: AVPlayerLayer

        init(viewModel: VideoPlayerViewModel) {
            playerLayer = AVPlayerLayer(player: viewModel.player)
        }
    }
}
