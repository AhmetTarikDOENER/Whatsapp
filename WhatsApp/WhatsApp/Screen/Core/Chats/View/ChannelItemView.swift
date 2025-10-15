import SwiftUI

struct ChannelItemView: View {
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
            Text("John Applause")
                .lineLimit(1)
                .bold()
            
            Spacer()
            
            Text("5:12 PM")
                .foregroundStyle(.gray)
                .font(.system(size: 15))
        }
    }
    
    private func lastMessageTypePreview() -> some View {
        Text("Hey welcome")
            .font(.system(size: 16))
            .lineLimit(2)
            .foregroundStyle(.gray)
    }
}

#Preview {
    ChannelItemView()
}
