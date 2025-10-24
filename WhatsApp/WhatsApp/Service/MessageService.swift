import Foundation

struct MessageService {
    
    static func sendTextMessage(
        to channel: Channel,
        from currentUser: User,
        _ textMessage: String,
        onComplete: () -> Void
    ) {
        let timestamp = Date().timeIntervalSince1970
        guard let messageId = FirebaseConstants.MessagesReference.childByAutoId().key else { return }
        let channelDictionary: [String: Any] = [
            .lastMessage: textMessage,
            .lastMessageTimestamp: timestamp
        ]
        
        let messageDictionary: [String: Any] = [
            .text: textMessage,
            .type: MessageType.text.title,
            .timestamp: timestamp,
            .ownerUid: currentUser.uid
        ]
        
        FirebaseConstants.ChannelsReference.child(channel.id).updateChildValues(channelDictionary)
        FirebaseConstants.MessagesReference.child(channel.id).child(messageId).setValue(messageDictionary)
        
        onComplete()
    }
    
    static func getMessages(for channel: Channel, completion: @escaping ([MessageItem]) -> Void) {
        FirebaseConstants.MessagesReference.child(channel.id).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            var messages: [MessageItem] = []
            dictionary.forEach { key, value in
                let messageDictionary = value as? [String: Any] ?? [:]
                let message = MessageItem(id: key, isGroupChat: channel.isGroupChat, dictionary: messageDictionary)
                messages.append(message)
                if messages.count == snapshot.childrenCount {
                    messages.sort { $0.timestamp < $1.timestamp }
                    completion(messages)
                }
            }
        } withCancel: { error in
            print("Failed to get messages for \(channel.title)")
        }
    }
    
    static func sendMediaMessage(to channel: Channel, parameters: MessageUploadParameters, completion: @escaping () -> Void) {
        guard let messageId = FirebaseConstants.MessagesReference.childByAutoId().key else { return }
        let timestamp = Date().timeIntervalSince1970
        
        let channelDictionary: [String: Any] = [
            .lastMessage: parameters.text,
            .lastMessageTimestamp: timestamp,
            .lastMessageType: parameters.type.title
        ]
        
        var messageDictionary: [String: Any] = [
            .text: parameters.text,
            .type: parameters.type.title,
            .timestamp: timestamp,
            .ownerUid: parameters.ownerUid,
        ]
        
        /// Photo Messages
        messageDictionary[.thumbnailUrl] = parameters.thumbnailURL ?? nil
        messageDictionary[.thumbnailWidth] = parameters.thumbnailWidth ?? nil
        messageDictionary[.thumbnailHeight] = parameters.thumbnailHeight ?? nil
        
        FirebaseConstants.ChannelsReference.child(channel.id).updateChildValues(channelDictionary)
        FirebaseConstants.MessagesReference.child(channel.id).child(messageId).setValue(messageDictionary)
        
        completion()
    }
}

struct MessageUploadParameters {
    let channel: Channel
    let text: String
    let type: MessageType
    let attachment: MediaAttachment
    var thumbnailURL: String?
    var videoUrl: String?
    var sender: User
    var audioUrl: String?
    var audioDuration: TimeInterval?
    
    var ownerUid: String {
        sender.uid
    }
    
    var thumbnailWidth: CGFloat? {
        guard type == .photo || type == .video else { return nil }
        return attachment.thumbnail.size.width
    }
    
    var thumbnailHeight: CGFloat? {
        guard type == .photo || type == .video else { return nil }
        return attachment.thumbnail.size.height
    }
}
