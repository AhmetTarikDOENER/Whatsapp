import SwiftUI
import FirebaseAuth

struct MessageItem: Identifiable {
    let id: String
    let text: String
    let messageType: MessageType
    let ownerUid: String
    let timestamp: Date
    var direction: MessageDirection {
        ownerUid == Auth.auth().currentUser?.uid ? .outgoing : .incoming
    }
    
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
        id: UUID().uuidString,
        text: "Hey Jen! How're you today?",
        messageType: .text,
        ownerUid: "1",
        timestamp: Date()
    )
    
    static let receivedPlaceholder = MessageItem(
        id: UUID().uuidString,
        text: "Hey John! Doing great😀, what about you?",
        messageType: .text,
        ownerUid: "2",
        timestamp: Date()
    )
    
    static let stubMessages: [MessageItem] = [
        .init(id: UUID().uuidString, text: "Hi, There!", messageType: .text, ownerUid: "1", timestamp: Date()),
        .init(id: UUID().uuidString, text: "Check this photo", messageType: .photo, ownerUid: "2", timestamp: Date()),
        .init(id: UUID().uuidString, text: "Watch this video", messageType: .video, ownerUid: "3", timestamp: Date()),
        .init(id: UUID().uuidString, text: "Listen to this", messageType: .audio, ownerUid: "4", timestamp: Date()),
    ]
}

extension MessageItem {
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.text = dictionary[.text] as? String ?? ""
        let type = dictionary[.type] as? String ?? ""
        self.messageType = MessageType(type)
        self.ownerUid = dictionary[.ownerUid] as? String ?? ""
        let timeInterval = dictionary[.timestamp] as? TimeInterval ?? 0
        self.timestamp = Date(timeIntervalSince1970: timeInterval)
    }
}

extension String {
    static let `type` = "type"
    static let timestamp = "timestamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
}
