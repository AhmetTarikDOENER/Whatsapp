import SwiftUI

struct BubbleTextView: View {
    
    let item: MessageItem
    
    var body: some View {
        VStack(alignment: item.horizontalAlignment, spacing: 4) {
            Text("Hi Jen! How're you today?")
                .padding(12)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .applyTail(item.direction)
            
            timeStampTextView()
        }
        .shadow(
            color: Color(.systemGray3).opacity(0.4),
            radius: 5, x: 0, y: 20
        )
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.direction == .incoming ? 5 : 100)
        .padding(.trailing, item.direction == .incoming ? 100 : 5)
    }
    
    private func timeStampTextView() -> some View {
        HStack {
            Text("12:34 PM")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
            
            if item.direction == .outgoing {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color(.systemBlue))
            }
        }
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
