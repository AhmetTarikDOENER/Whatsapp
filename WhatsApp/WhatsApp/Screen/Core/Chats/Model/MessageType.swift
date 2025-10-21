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
    case admin(_ type: AdminMessageType), text, photo, video, audio
    
    init?(_ stringValue: String) {
        switch stringValue {
        case .text: self = .text
        case "photo": self = .photo
        case "video": self = .video
        default:
            if let adminMessageType = AdminMessageType(rawValue: stringValue) {
                self = .admin(adminMessageType)
            } else {
                return nil
            }
        }
    }
    
    var title: String {
        switch self {
        case .admin: "admin"
        case .text: "text"
        case .photo: "photo"
        case .video: "video"
        case .audio: "audio"
        }
    }
}

extension MessageType: Equatable {
    static func ==(lhs: MessageType, rhs: MessageType) -> Bool {
        switch(lhs, rhs) {
        case (.admin(let leftAdmin), .admin(let rightAdmin)):
            return leftAdmin == rightAdmin
        case (.text, .text),
             (.photo, .photo),
             (.video, .video),
             (.audio, .audio):
            return true
        default: return false
        }
    }
}
