import Firebase
import FirebaseStorage

enum FirebaseConstants {
    private static let DatabaseReference = Database.database().reference()
    static let UserReference = DatabaseReference.child("users")
    static let ChannelsReference = DatabaseReference.child("channels")
    static let MessagesReference = DatabaseReference.child("channel-messages")
    static let UserChannelsReference = DatabaseReference.child("user-channels")
    static let UserDirectChannels = DatabaseReference.child("user-direct-channels")
}
