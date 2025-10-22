import SwiftUI

struct BubbleTextView: View {
    
    let item: MessageItem
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if item.showGroupPartnerInfo {
                CircularProfileImageView(item.sender?.profileImageUrl, size: .mini)
            }
            
            if item.direction == .outgoing {
                timeStampTextView()
            }
            
            Text(item.text)
                .padding(12)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .applyTail(item.direction)
            
            if item.direction == .incoming {
                timeStampTextView()
            }
        }
        .shadow(
            color: Color(.systemGray3).opacity(0.4),
            radius: 5, x: 0, y: 20
        )
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
    }
    
    private func timeStampTextView() -> some View {
        Text(item.timestamp.formatToTime)
            .font(.footnote)
            .foregroundStyle(.gray)
    }
}

#Preview {
    ScrollView {
        BubbleTextView(item: .sentPlaceholder)
        BubbleTextView(item: .receivedPlaceholder)
    }
    .frame(maxWidth: .infinity)
    .background(.gray.opacity(0.1))
}
