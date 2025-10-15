import SwiftUI

struct MessageItem: Identifiable {
    let id = UUID().uuidString
    let text: String
    let direction: MessageDirection
    
    var backgroundColor: Color {
        return direction == .outgoing ? Color.bubbleGreen : .bubbleWhite
    }
    
    var alignment: Alignment {
        return direction == .incoming ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .incoming ? .leading : .trailing
    }
}

extension MessageItem {
    static let sentPlaceholder = MessageItem(
        text: "Hey Jen! How're you today?",
        direction: .outgoing
    )
    
    static let receivedPlaceholder = MessageItem(
        text: "Hey John! Doing great😀, what about you?",
        direction: .incoming
    )
}

enum MessageDirection: String, CaseIterable {
    case incoming
    case outgoing
    
    static var random: MessageDirection {
        return [MessageDirection.incoming, .outgoing].randomElement() ?? .incoming
    }
}
