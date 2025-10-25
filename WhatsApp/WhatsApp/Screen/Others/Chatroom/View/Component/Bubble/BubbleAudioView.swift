import SwiftUI
import AVKit

struct BubbleAudioView: View {
    
    let item: MessageItem
    @State private var sliderValue: Double = 0
    @State private var sliderRange: ClosedRange<Double> = 0...20
    @EnvironmentObject private var audioMessagePlayer: AudioMessagePlayer
    @State private var playbackState: AudioMessagePlayer.PlaybackState = .stopped
    @State private var playbackTime = "00:00"
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if item.showGroupPartnerInfo {
                CircularProfileImageView(size: .mini)
                    .offset(y: 2)
            }
            
            HStack {
                playButton()
                
                Slider(value: $sliderValue, in: sliderRange)
                    .tint(.gray)
                
                Text("03:00")
                    .foregroundStyle(.gray)
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .background(item.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .applyTail(item.direction)
            
            if item.direction == .outgoing {
                timestampView()
            }
        }
        .shadow(
            color: Color(.systemGray5).opacity(0.1),
            radius: 5,
            x: 0,
            y: 20
        )
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
        .onReceive(audioMessagePlayer.$playbackState) { state in
            observePlaybackState(state)
        }
        .onReceive(audioMessagePlayer.$currentTime) { currentTime in
            observe(to: currentTime)
        }
        .onReceive(audioMessagePlayer.$playerItem) { playerItem in
            guard let audioDuration = item.audioDuration else { return }
            sliderRange = 0...audioDuration
        }
    }
    
    private func playButton() -> some View {
        Button {
            handlePlayAudioMessage()
        } label: {
            Image(systemName: "play.fill")
                .padding(12)
                .background(item.direction == .incoming ? .green : .white)
                .clipShape(Circle())
                .foregroundStyle(item.direction == .incoming ? .white : .black)
        }
    }
    
    private func timestampView() -> some View {
        Text("12:34")
            .font(.footnote)
            .foregroundStyle(.gray)
    }
}

//  MARK: - BubbleAudioView+PlaybackState
private extension BubbleAudioView {
    private func handlePlayAudioMessage() {
        if playbackState == .stopped || playbackState == .paused {
            guard let audioMessageURLString = item.audioURL,
                  let audioMessageURL = URL(string: audioMessageURLString) else { return }
            audioMessagePlayer.playAudio(from: audioMessageURL)
        } else {
            audioMessagePlayer.pauseAudio()
        }
    }
    
    private func observePlaybackState(_ state: AudioMessagePlayer.PlaybackState) {
        if state == .stopped {
            playbackState = .stopped
            sliderValue = 0
        } else {
            playbackState = state
        }
    }
    
    private func observe(to currentTime: CMTime) {
        playbackTime = currentTime.seconds.formatElapsedTime
        sliderValue = currentTime.seconds
    }
}

#Preview {
    ScrollView {
        BubbleAudioView(item: .receivedPlaceholder)
        BubbleAudioView(item: .sentPlaceholder)
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal)
    .background(.gray.opacity(0.5))
    .onAppear {
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
}
