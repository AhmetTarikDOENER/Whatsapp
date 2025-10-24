import SwiftUI
import PhotosUI

struct ChatroomView: View {
    
    //  MARK: - Properties
    let channel: Channel
    @StateObject private var viewModel: ChatroomViewModel
    
    //  MARK: - Initializer
    init(channel: Channel) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatroomViewModel(channel))
    }
    
    //  MARK: - Body
    var body: some View {
        MessageListView(viewModel)
            .toolbar {
                makeLeadingNavigationItems()
                makeTrailingNavigationGroupItems()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .photosPicker(
                isPresented: $viewModel.showPhotoPicker,
                selection: $viewModel.photoPickerItems,
                maxSelectionCount: 6,
                photoLibrary: .shared()
            )
            .ignoresSafeArea(edges: .bottom)
            .safeAreaInset(edge: .bottom) {
                bottomSafeAreaView()
            }
            .animation(.easeInOut, value: viewModel.showPhotoPickerPreview)
            .fullScreenCover(isPresented: $viewModel.videoPlayerState.show) {
                if let player = viewModel.videoPlayerState.player {
                    MediaPlayerView(player: player) {
                        viewModel.dismissMediaPlayer()
                    }
                }
            }
    }
}

//  MARK: - ChatroomView+Extension
extension ChatroomView {
    
    private var channelTitle: String {
        let maxCharacterCount = 20
        let trailingCharacters = channel.title.count > maxCharacterCount ? "..." : ""
        let title = String(channel.title.prefix(maxCharacterCount) + trailingCharacters)
        
        return title
    }
    
    @ToolbarContentBuilder
    private func makeLeadingNavigationItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                CircularProfileImageView(channel, size: .mini)
                
                Text(channelTitle)
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func makeTrailingNavigationGroupItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            makeVideoCallButton()
            makeVoiceCallButton()
        }
    }
    
    private func makeVideoCallButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "video")
        }
    }
    
    private func makeVoiceCallButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "phone")
        }
    }
    
    private func bottomSafeAreaView() -> some View {
        VStack(spacing: 0) {
            Divider()
            
            if viewModel.showPhotoPickerPreview {
                MediaAttachmentPreview(mediaAttachments: viewModel.mediaAttachments) { action in
                    viewModel.handleMediaAttachmentPreview(action)
                }
                Divider()
            }
            
            TextInputArea(
                textMessage: $viewModel.textMessage,
                isRecording: $viewModel.isRecordingAudioMessage,
                elapsedTime: $viewModel.elapsedAudioMessageTime) { action in
                    viewModel.handleTextInputArea(action)
                }
        }
    }
}

#Preview {
    NavigationStack {
        ChatroomView(channel: .placeholder)
    }
}
