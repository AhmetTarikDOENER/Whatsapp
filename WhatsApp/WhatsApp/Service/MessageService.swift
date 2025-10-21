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
}
