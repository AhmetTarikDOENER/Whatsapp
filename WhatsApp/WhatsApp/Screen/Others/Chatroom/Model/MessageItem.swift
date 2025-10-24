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
    let thumbnailURL: String?
    var thumbnailHeight: CGFloat?
    var thumbnailWidth: CGFloat?
    var videoURL: String?
    var audioURL: String?
    var audioDuration: TimeInterval?
    
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
    
    var imageSize: CGSize {
        let photoWidth = thumbnailWidth ?? 0
        let photoHeight = thumbnailHeight ?? 0
        let imageHeight = CGFloat(photoHeight / photoWidth * imageWidth)
        
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    var imageWidth: CGFloat {
        let photoWidth = (UIWindowScene.currentWindowScene?.screenWidth ?? 0) / 1.5
        return photoWidth
    }
}

extension MessageItem {
    static let sentPlaceholder = MessageItem(
        id: UUID().uuidString,
        isGroupChat: true,
        text: "Hey Jen! How're you today?",
        messageType: .text,
        ownerUid: "1",
        timestamp: Date(), thumbnailURL: nil
    )
    
    static let receivedPlaceholder = MessageItem(
        id: UUID().uuidString,
        isGroupChat: false,
        text: "Hey John! Doing great😀, what about you?",
        messageType: .text,
        ownerUid: "2",
        timestamp: Date(), thumbnailURL: nil
    )
    
    static let stubMessages: [MessageItem] = [
        .init(id: UUID().uuidString, isGroupChat: true, text: "Hi, There!", messageType: .text, ownerUid: "1", timestamp: Date(), thumbnailURL: nil),
        .init(id: UUID().uuidString, isGroupChat: false, text: "Check this photo", messageType: .photo, ownerUid: "2", timestamp: Date(), thumbnailURL: nil),
        .init(id: UUID().uuidString, isGroupChat: true, text: "Watch this video", messageType: .video, ownerUid: "3", timestamp: Date(), thumbnailURL: nil),
        .init(id: UUID().uuidString, isGroupChat: false, text: "Listen to this", messageType: .audio, ownerUid: "4", timestamp: Date(), thumbnailURL: nil),
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
        self.thumbnailURL = dictionary[.thumbnailUrl] as? String ?? nil
        self.thumbnailWidth = dictionary[.thumbnailWidth] as? CGFloat ?? nil
        self.thumbnailHeight = dictionary[.thumbnailHeight] as? CGFloat ?? nil
        self.videoURL = dictionary[.videoURL] as? String ?? nil
        self.audioURL = dictionary[.audioURL] as? String ?? nil
        self.audioDuration = dictionary[.audioDuration] as? TimeInterval ?? nil
    }
}

extension String {
    static let `type` = "type"
    static let timestamp = "timestamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
    static let thumbnailWidth = "thumbnailWidth"
    static let thumbnailHeight = "thumbnailHeight"
    static let videoURL = "videoURL"
    static let audioURL = "audioURL"
    static let audioDuration = "audioDuration"
}
