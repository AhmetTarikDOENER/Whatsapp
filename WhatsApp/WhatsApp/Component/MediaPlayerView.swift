import SwiftUI
import AVKit

struct MediaPlayerView: View {
    let player: AVPlayer
    let dismissPlayer: () -> Void
    
    var body: some View {
        VideoPlayer(player: player)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .overlay(alignment: .topLeading){
                cancelButton()
                    .padding()
            }
            .onAppear { player.play() }
    }
    
    private func cancelButton() -> some View {
        Button {
            dismissPlayer()
        } label: {
            Image(systemName: "xmark")
                .scaledToFit()
                .imageScale(.large)
                .padding(10)
                .foregroundStyle(.white)
                .background(.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 4)
                .padding(2)
                .bold()
        }
    }
}

//#Preview {
//    MediaPlayerView()
//}
