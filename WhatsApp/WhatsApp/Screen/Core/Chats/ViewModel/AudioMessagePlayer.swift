import Foundation
import AVFoundation

final class AudioMessagePlayer: ObservableObject {
    
    private var player: AVPlayer?
    private var currentURL: URL?
    private var currentTimeObserver: Any?
    @Published private(set) var playerItem: AVPlayerItem?
    @Published private(set) var playbackState: PlaybackState = .stopped
    @Published private(set) var currentTime = CMTime.zero
    
    deinit {
        tearDown()
    }
    
    func playAudio(from url: URL) {
        if let currentURL, currentURL == url {
            /// Resumes a previous message which already playing
            resumePlaying()
        } else {
            /// Plays voice message
            currentURL = url
            let playerItem = AVPlayerItem(url: url)
            self.playerItem = playerItem
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            playbackState = .playing
            observeCurrentPlayerTime()
            observeEndOfPlayback()
        }
    }
    
    func pauseAudio() {
        player?.pause()
        playbackState = .paused
    }
    
    func seek(to timeInterval: TimeInterval) {
        guard let player else { return }
        let targetTime = CMTime(seconds: timeInterval, preferredTimescale: 1)
        player.seek(to: targetTime)
    }
    
    
    //  MARK: - Private
    private func observeCurrentPlayerTime() {
        currentTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] time in
            self?.currentTime = time
        }
    }
    
    private func observeEndOfPlayback() {
        NotificationCenter.default.addObserver(
            forName: AVPlayerItem.didPlayToEndTimeNotification,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.stopAudio()
            print("observeEndOfPlayback")
        }
    }
    
    private func resumePlaying() {
        if playbackState == .paused || playbackState == .stopped {
            player?.play()
            playbackState = .playing
        }
    }
    
    private func stopAudio() {
        player?.pause()
        player?.seek(to: .zero)
        playbackState = .stopped
        currentTime = .zero
    }
    
    private func removeObservers() {
        guard let currentTimeObserver else { return }
        player?.removeTimeObserver(currentTimeObserver)
        self.currentTimeObserver = nil
        print("removeObservers fired")
    }
    
    private func tearDown() {
        removeObservers()
        player = nil
        playerItem = nil
        currentURL = nil
    }
}

extension AudioMessagePlayer {
    enum PlaybackState {
        case stopped, playing, paused
    }
}
