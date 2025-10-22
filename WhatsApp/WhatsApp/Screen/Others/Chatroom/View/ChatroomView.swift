import SwiftUI

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
            .safeAreaInset(edge: .bottom) {
                TextInputArea(textMessage: $viewModel.textMessage) {
                    viewModel.sendMessage()
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
}

#Preview {
    NavigationStack {
        ChatroomView(channel: .placeholder)
    }
}
