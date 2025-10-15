import SwiftUI

struct BubbleTailView: View {
    
    //  MARK: - Properties
    var direction: MessageDirection
    
    private var backgroundColor: Color {
        return direction == .incoming ? .bubbleWhite : .bubbleGreen
    }
    
    //  MARK: - Body
    var body: some View {
        Image(direction == .outgoing ? .outgoingTail : .incomingTail)
            .renderingMode(.template)
            .resizable()
            .frame(width: 10, height: 10)
            .offset(y: 3)
            .foregroundStyle(backgroundColor)
    }
}

#Preview {
    ScrollView {
        BubbleTailView(direction: .incoming)
        BubbleTailView(direction: .outgoing)
    }
    .frame(maxWidth: .infinity)
    .background(.gray.opacity(0.1))
}
