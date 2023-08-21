//
//  VideoPlayerViewController.swift
//  TheArcXP
//
//  Created by Mahesh Venkateswarlu on 5/25/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import UIKit
import AVKit
import ArcXP

public enum PlayerMode {
    case avPlayerViewController
    case arcMediaPlayerViewController
}

class ArcXPVideoPlayerViewController: UIViewController {
    
    public var playerMode: PlayerMode = .arcMediaPlayerViewController
    
    /// The `PlayerController` that was provided by the
    /// `playerControllerContainer`. **If you do not assign the player
    /// controller to an instance property, and you use the
    /// `AVPlayerViewController`, your app will crash because the
    /// `AVPlayerViewController` does *not* retain the `playerController`
    /// itself.
    private var playerController: PlayerController!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let playerViewController: UIViewController

        // Figure out which player controller container we want.
        if playerMode == .arcMediaPlayerViewController {
            let playerVC = ArcMediaPlayerViewController.loadFromStoryboard()
            playerVC.playerView.delegate = self
            playerController = playerVC.playerController
            playerViewController = playerVC
        } else {
            let playerVC = AVPlayerViewController()
            playerController = playerVC.playerController
            playerViewController = playerVC
        }
        playerController.delegate = self
        
        addChild(playerViewController)
        playerViewController.didMove(toParent: self)  // DON'T FORGET THIS!
        view.addSubview(playerViewController.view)
        let playerView = playerViewController.view!
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func log(_ message: String, time: CMTime) {
        print("ArcXP Video SDK: \(message)")
    }
    
    func playVideo(video: ArcVideo?) {
        if let video = video {
            let playerItem = AVPlayerItem(asset: video)
            playerController?.play(playerItem: playerItem)
        }
    }
    
    func loadVideo(video: ArcVideo?) {
        if let video = video {
            let playerItem = AVPlayerItem(asset: video)
            playerController?.load(playerItem: playerItem)
        }
    }
}

extension ArcXPVideoPlayerViewController: PlayerDelegate {
    // MARK: - Playback Milestones

    func player(_ player: AVPlayer, completed item: AVPlayerItem?) {
        log("Video completed", time: player.currentTime())
    }

    func player(_ player: AVPlayer, played25Percent video: AVPlayerItem?) {
        log("Video is 25% finished", time: player.currentTime())
    }

    func player(_ player: AVPlayer, played50Percent video: AVPlayerItem?) {
        log("Video is 50% finished", time: player.currentTime())
    }

    func player(_ player: AVPlayer, played75Percent video: AVPlayerItem?) {
        log("Video is 75% finished", time: player.currentTime())
    }

    // MARK: - User Interaction

    func playerMuted(_ player: AVPlayer) {
        log("Player muted", time: player.currentTime())
    }

    func playerUnmuted(_ player: AVPlayer) {
        log("Player unmuted", time: player.currentTime())
    }

    func player(_ player: AVPlayer, paused video: AVPlayerItem?) {
        log("Video paused", time: player.currentTime())
    }

    func player(_ player: AVPlayer, resumed item: AVPlayerItem?) {
        log("Video resumed", time: player.currentTime())
    }

    func player(_ player: AVPlayer, skipped item: AVPlayerItem?, to time: CMTime) {
        log("Video skipped to \(time.seconds)", time: player.currentTime())
    }

    func player(_ player: AVPlayer, started video: AVPlayerItem?, byUser: Bool) {
        log("Video started" + (byUser ? " by the user" : " automatically"), time: player.currentTime())
    }

    func playerTapped(_ player: AVPlayer, item: AVPlayerItem?) {
        log("Player tapped", time: player.currentTime())
    }

    func playerBeganFullScreenPresentation(_ player: AVPlayer, item: AVPlayerItem?) {
        log("Player went into fullscreen mode", time: player.currentTime())
    }

    func playerEndedFullScreenPresentation(_ player: AVPlayer, item: AVPlayerItem?) {
        log("Player returned from fullscreen mode", time: player.currentTime())
    }
}

extension ArcXPVideoPlayerViewController: ArcMediaPlayerViewDelegate {

    func playerViewControlBarDidAppear(_ playerView: ArcMediaPlayerView) {
        log("Control bar appeared", time: playerView.player.currentTime())
    }

    func playerViewControlBarWillAppear(_ playerView: ArcMediaPlayerView) {
        log("Control bar will appear", time: playerView.player.currentTime())
    }

    func playerViewControlBarDidDisappear(_ playerView: ArcMediaPlayerView) {
        log("Control bar disappeared", time: playerView.player.currentTime())
    }

    func playerViewControlBarWillDisappear(_ playerView: ArcMediaPlayerView) {
        log("Control bar will disappear", time: playerView.player.currentTime())
    }
}
