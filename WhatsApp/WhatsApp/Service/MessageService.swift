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
}

struct MessageUploadParameters {
    let channel: Channel
    let text: String
    let type: MessageType
    let attachment: MediaAttachment
    var thumbnail: String?
    var videoUrl: String?
    var sender: User
    var audioUrl: String?
    var audioDuration: TimeInterval?
    
    
}
