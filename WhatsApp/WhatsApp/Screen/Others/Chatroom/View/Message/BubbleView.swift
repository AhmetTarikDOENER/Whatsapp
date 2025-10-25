import SwiftUI

struct BubbleView: View {
    
    let message: MessageItem
    let channel: Channel
    let isNewDay: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isNewDay {
                newDayTimeTimestapTextView()
            }

            composeDynamicBubbleView()
        }
    }
    
    @ViewBuilder
    private func composeDynamicBubbleView() -> some View {
        switch message.messageType {
        case .text:
            BubbleTextView(item: message)
        case .photo, .video:
            BubbleImageView(item: message)
        case .audio:
            BubbleAudioView(item: message)
        case .admin(let adminType):
            switch adminType {
            case .channelCreation:
                ChannelCreationTextView()
                if channel.isGroupChat {
                    AdminMessageTextView(channel: channel)
                }
            default:
                Text("Unknown")
            }
        }
    }
    
    private func newDayTimeTimestapTextView() -> some View {
        Text(message.timestamp.relativeDateString)
            .font(.caption)
            .bold()
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
            .background(.whatsAppGray)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    BubbleView(
        message: .sentPlaceholder,
        channel: .placeholder,
        isNewDay: false
    )
}
