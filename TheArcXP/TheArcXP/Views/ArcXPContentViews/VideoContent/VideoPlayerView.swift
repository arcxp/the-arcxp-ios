//
//  VideoPlayerView.swift
//  TheArcXP
//
//  Created by Mahesh Venkateswarlu on 5/18/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import AVKit
import ArcXP

struct VideoPlayerView: View {

    @State private var arcVideo: ArcVideo?
    var isFullScreen: Bool
    var storyIdentifier: String?
    @State private var showPaywallScreen: Bool = false

    init(storyIdentfier: String? = nil, isFullScreen: Bool = true) {
        self.storyIdentifier = storyIdentfier
        self.isFullScreen = isFullScreen
    }

    var body: some View {
        if isFullScreen {
            ArcPlayerViewController(arcVideo: $arcVideo, playOnLoad: isFullScreen)
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: fetchVideoContent)
                .paywall(isShowing: $showPaywallScreen)
        } else {
            ArcPlayerViewController(arcVideo: $arcVideo)
                .transition(.move(edge: .bottom))
                .onAppear(perform: fetchVideoContent)
        }
    }

    func fetchVideoContent() {
        guard let storyIdentifier = storyIdentifier else {
            return
        }
        showPaywallScreen = PaywallLoader.shouldShowPaywall(contentID: storyIdentifier, contentType: .video)

        // If paywall screen is shown, avoid proceeding further
        guard !showPaywallScreen else {
            return
        }
        ArcMediaClientManager.client.video(mediaID: storyIdentifier,
                                           adSettings: nil,
                                           accessToken: "unused") { (videoResult) in
            switch videoResult {
            case .success(let arcVideo):
                self.arcVideo = arcVideo
            case .failure:
                print("Video render failure")
            }
        }
    }
}

struct AVPlayerView: UIViewControllerRepresentable {

    @Binding var url: URL?

    private var player: AVPlayer? {
        guard let url = url else { return nil }
        return AVPlayer(url: url)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        playerController.allowsPictureInPicturePlayback = true
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}

struct ArcPlayerViewController: UIViewControllerRepresentable {
    @Binding var arcVideo: ArcVideo?
    var playOnLoad: Bool = false

    func makeUIViewController(context: Context) -> ArcXPVideoPlayerViewController {
        ArcXPVideoPlayerViewController()
    }

    func updateUIViewController(_ uiViewController: ArcXPVideoPlayerViewController, context: Context) {
        uiViewController.playerMode = PlayerMode.arcMediaPlayerViewController
        if playOnLoad {
            uiViewController.playVideo(video: arcVideo)
        } else {
            uiViewController.loadVideo(video: arcVideo)
        }
    }
}
