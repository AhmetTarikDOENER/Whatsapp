//  MARK: - User
struct User: Identifiable, Hashable, Decodable {
    let uid: String
    let username: String
    let email: String
    var bio: String? = nil
    var profileImageUrl: String? = nil
    
    var id: String { uid }
    
    var bioUnwrapped: String { bio ?? "Hey there! I am using WhatsApp." }
}

extension User {
    static let placeholder = User(uid: "123", username: "Place Holder", email: "placeholder@gmail.com")
    static let placeholders: [User] = [
        .init(uid: "1", username: "Berke", email: "berke@gmail.com"),
        .init(uid: "2", username: "Irem", email: "irem@gmail.com", bio: "Türk! Ögün, calis, güven."),
        .init(uid: "3", username: "Asli", email: "asli@gmail.com", bio: "Türk! Ögün, calis, güven."),
        .init(uid: "4", username: "Can", email: "can@gmail.com", bio: "Türk! Ögün, calis, güven."),
        .init(uid: "5", username: "Yagmur", email: "yagmur@gmail.com", bio: "Türk! Ögün, calis, güven."),
        .init(uid: "6", username: "Sila", email: "sila@gmail.com", bio: "Türk! Ögün, calis, güven."),
        .init(uid: "7", username: "Tarik", email: "tarik@gmail.com", bio: "Türk! Ögün, calis, güven."),
        .init(uid: "8", username: "Mahmut", email: "mahmut@gmail.com", bio: "Türk! Ögün, calis, güven."),
        .init(uid: "9", username: "Ayse", email: "ayse@gmail.com", bio: "Türk! Ögün, calis, güven."),
        .init(uid: "10", username: "Faruk", email: "faruk@gmail.com", bio: "Türk! Ögün, calis, güven."),
    ]
}

extension User {
    init(dictionary: [String: Any]) {
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String ?? nil
    }
}

extension String {
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}
