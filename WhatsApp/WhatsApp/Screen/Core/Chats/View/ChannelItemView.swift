import SwiftUI

struct ChannelItemView: View {
    
    let channel: Channel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                makeTitleAndTimestampView()
                lastMessageTypePreview()
            }
        }
    }
    
    private func makeTitleAndTimestampView() -> some View {
        HStack {
            Text(channel.title)
                .lineLimit(2)
                .bold()
            
            Spacer()
            
            Text("5:12 PM")
                .foregroundStyle(.gray)
                .font(.system(size: 15))
        }
    }
    
    private func lastMessageTypePreview() -> some View {
        Text(channel.lastMessage)
            .font(.system(size: 16))
            .lineLimit(2)
            .foregroundStyle(.gray)
    }
}

#Preview {
    ChannelItemView(channel: .placeholder)
}
