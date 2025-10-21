import Foundation

enum AdminMessageType: String {
    case channelCreation
    case memberAdded
    case memberLeft
    case channelNameChanged
}

enum MessageDirection: String, CaseIterable {
    case incoming
    case outgoing
    
    static var random: MessageDirection {
        return [MessageDirection.incoming, .outgoing].randomElement() ?? .incoming
    }
}

enum MessageType {
    case text, photo, video, audio
    
    init(_ stringValue: String) {
        switch stringValue {
        case .text: self = .text
        case "photo": self = .photo
        case "video": self = .video
        default: self = .text
        }
    }
    
    var title: String {
        switch self {
        case .text: "text"
        case .photo: "photo"
        case .video: "video"
        case .audio: "audio"
        }
    }
}
