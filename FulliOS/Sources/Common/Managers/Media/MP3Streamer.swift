//
//  MP3Streamer.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 6/6/2024.
//

import AVFoundation
import Foundation

internal class MP3Streamer {
    static let shared = MP3Streamer()
    private var audioPlayer: AVPlayer?
    private var isPlaying = false

    private init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Logger.shared.log("Failed to set up audio session: \(error)")
        }
    }

    func initialize(with url: String) {
        guard let streamURL = URL(string: url) else {
            Logger.shared.log("Invalid URL")
            return
        }
        let playerItem = AVPlayerItem(url: streamURL)
        audioPlayer = AVPlayer(playerItem: playerItem)
    }

    func play() {
        guard let player = audioPlayer else {
            Logger.shared.log("Audio player not initialized")
            return
        }
        player.play()
        isPlaying = true
    }

    func stop() {
        audioPlayer?.pause()
        isPlaying = false
    }

    func release() {
        stop()
        audioPlayer = nil
    }

    func restart() {
        if let player = audioPlayer, isPlaying {
            player.seek(to: CMTime.zero)
            player.play()
        } else {
            Logger.shared.log("Audio player not initialized or not playing")
        }
    }
}
