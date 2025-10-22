import SwiftUI

struct BubbleImageView: View {
    
    //  MARK: - Properties
    let item: MessageItem
    
    //  MARK: - Body
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if item.direction == .outgoing { Spacer() }
            
            if item.showGroupPartnerInfo {
                CircularProfileImageView(size: .mini)
                    .offset(y: 2)
            }
            
            messageTextView()
                .shadow(
                    color: Color(.systemGray3).opacity(0.1),
                    radius: 5,
                    x: 0,
                    y: 20
                )
                .overlay {
                    playButton()
                        .opacity(item.messageType == .video ? 1 : 0)
                }
            
            if item.direction == .incoming { Spacer() }
        }
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
    }
}

//  MARK: - BubbleImageView+Extension
extension BubbleImageView {
    private func shareButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "arrowshape.turn.up.right.fill")
                .padding(10)
                .foregroundStyle(.white)
                .background(.gray)
                .background(.thinMaterial)
                .clipShape(Circle())
        }
    }
    
    private func messageTextView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(.stubImage0)
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.systemGray5))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(.systemGray5))
                )
                .padding(8)
                .overlay(alignment: .bottomTrailing) {
                    timestampTextView()
                }
            
            if !item.text.isEmptyOrWhitespace {
                Text(item.text)
                    .padding([.horizontal, .bottom], 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(width: 220)
            }
        }
        .background(item.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .applyTail(item.direction)
    }
    
    private func timestampTextView() -> some View {
        HStack {
            Text("12:34")
                .font(.system(size: 12))

            if item.direction == .outgoing {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15, height: 15)
            }
        }
        .padding(.vertical, 2.5)
        .padding(.horizontal, 8)
        .foregroundStyle(.white)
        .background(Color(.systemGray5))
        .clipShape(Capsule())
        .padding(12)
    }
    
    private func playButton() -> some View {
        Image(systemName: "play.fill")
            .padding()
            .imageScale(.large)
            .foregroundStyle(.gray)
            .background(.thinMaterial)
            .clipShape(Circle())
    }
}

#Preview {
    ScrollView {
        BubbleImageView(item: .sentPlaceholder)
        BubbleImageView(item: .receivedPlaceholder)
    }
    .frame(maxWidth: .infinity)
    .background(.gray.opacity(0.4))
}
