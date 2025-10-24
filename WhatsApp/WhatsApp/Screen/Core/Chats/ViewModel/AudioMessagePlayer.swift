import Foundation
import AVFoundation

final class AudioMessagePlayer: ObservableObject {
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var currentURL: URL?
    private var playbackState: PlaybackState = .stopped
    private var currentTime = CMTime.zero
    private var currentTimeObserver: Any?
    
    func playAudio(from url: URL) {
        currentURL = url
        let playerItem = AVPlayerItem(url: url)
        self.playerItem = playerItem
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        playbackState = .playing
        observeCurrentPlayerTime()
    }
    
    func pauseAudio() {
        
    }
    
    func seek(to timeInterval: TimeInterval) {
        
    }
    
    //  MARK: - Private
    private func observeCurrentPlayerTime() {
        currentTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] time in
            self?.currentTime = time
        }
    }
}

extension AudioMessagePlayer {
    enum PlaybackState {
        case stopped, playing, paused
    }
}
