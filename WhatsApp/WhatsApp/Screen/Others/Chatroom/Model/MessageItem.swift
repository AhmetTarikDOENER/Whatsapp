import SwiftUI
import FirebaseAuth

struct MessageItem: Identifiable {
    let id: String
    let isGroupChat: Bool
    let text: String
    let messageType: MessageType
    let ownerUid: String
    let timestamp: Date
    var sender: User?
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
    
    var showGroupPartnerInfo: Bool {
        isGroupChat && direction == .incoming
    }
    
    private let horizontalPadding: CGFloat = 24
    var leadingPadding: CGFloat {
        direction == .incoming ? 0 : horizontalPadding
    }
    var trailingPadding: CGFloat {
        direction == .incoming ? horizontalPadding : 0
    }
}

extension MessageItem {
    static let sentPlaceholder = MessageItem(
        id: UUID().uuidString,
        isGroupChat: true,
        text: "Hey Jen! How're you today?",
        messageType: .text,
        ownerUid: "1",
        timestamp: Date()
    )
    
    static let receivedPlaceholder = MessageItem(
        id: UUID().uuidString,
        isGroupChat: false,
        text: "Hey John! Doing great😀, what about you?",
        messageType: .text,
        ownerUid: "2",
        timestamp: Date()
    )
    
    static let stubMessages: [MessageItem] = [
        .init(id: UUID().uuidString, isGroupChat: true, text: "Hi, There!", messageType: .text, ownerUid: "1", timestamp: Date()),
        .init(id: UUID().uuidString, isGroupChat: false, text: "Check this photo", messageType: .photo, ownerUid: "2", timestamp: Date()),
        .init(id: UUID().uuidString, isGroupChat: true, text: "Watch this video", messageType: .video, ownerUid: "3", timestamp: Date()),
        .init(id: UUID().uuidString, isGroupChat: false, text: "Listen to this", messageType: .audio, ownerUid: "4", timestamp: Date()),
    ]
}

extension MessageItem {
    init(id: String, isGroupChat: Bool, dictionary: [String: Any]) {
        self.id = id
        self.isGroupChat = isGroupChat
        self.text = dictionary[.text] as? String ?? ""
        let type = dictionary[.type] as? String ?? ""
        self.messageType = MessageType(type) ?? .text
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
