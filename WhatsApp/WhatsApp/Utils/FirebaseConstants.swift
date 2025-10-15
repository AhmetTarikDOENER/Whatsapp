import Firebase
import FirebaseStorage

enum FirebaseConstants {
    private static let DatabaseReference = Database.database().reference()
    static let UserReference = DatabaseReference.child("users")
}
