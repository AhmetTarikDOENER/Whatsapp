import SwiftUI

struct BubbleTextView: View {
    
    let item: MessageItem
    
    var body: some View {
        Text("Hi Jen! How're you today?")
            .padding(12)
            .background(item.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .applyTail(item.direction)
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
