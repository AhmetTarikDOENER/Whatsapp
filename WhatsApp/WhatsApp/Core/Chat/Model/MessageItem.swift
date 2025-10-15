import Foundation

struct MessageItem: Identifiable {
    let id = UUID().uuidString
    let text: String
    let direction: MessageDirection
}

enum MessageDirection: String, CaseIterable {
    case incoming
    case outgoing
    
    static var random: MessageDirection {
        return [MessageDirection.incoming, .outgoing].randomElement() ?? .incoming
    }
}
