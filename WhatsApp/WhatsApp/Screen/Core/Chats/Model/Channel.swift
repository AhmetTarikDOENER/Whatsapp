import Foundation
import FirebaseAuth

struct Channel: Identifiable, Hashable {
    var id: String
    var name: String?
    var lastMessage: String
    var creationDate: Date
    var lastMessageTimestamp: Date
    var membersCount: Int
    var adminUids: [String]
    var membersUids: [String]
    var members: [User]
    private var thumbnailUrl: String?
    let createdBy: String
    
    var isGroupChat: Bool {
        members.count > 2
    }
    
    var membersExcludingMe: [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        return members.filter { $0.uid != currentUid }
    }
    
    var title: String {
        if let name = name { return name }
        if isGroupChat {
            return groupMembersName
        } else {
            return membersExcludingMe.first?.username ?? "Unknown"
        }
    }
    
    var isCreatedByMe: Bool {
        createdBy == Auth.auth().currentUser?.uid ?? ""
    }
    
    var creatorName: String {
        members.first { $0.uid == createdBy }?.username ?? "Someone"
    }
    
    var coverImageUrl: String? {
        if let thumbnailUrl {
            return thumbnailUrl
        }
        
        if isGroupChat == false {
            return membersExcludingMe.first?.profileImageUrl
        }
        
        return nil
    }
    
    private var groupMembersName: String {
        let membersCount = membersCount - 1
        let fullNames: [String] = membersExcludingMe.map { $0.username }
        if membersCount == 2 {
            return fullNames.joined(separator: " and ")
        } else if membersCount > 2 {
            let remainingCounts = membersCount - 2
            return fullNames.prefix(2).joined(separator: ", ") + ", and \(remainingCounts) " + "others"
        }
        
        return "Unknown"
    }
    
    var allMembersFetched: Bool {
        members.count == membersCount
    }
}

extension Channel {
    init(_ dictionary: [String: Any]) {
        self.id = dictionary[.id] as? String ?? ""
        self.name = dictionary[.name] as? String? ?? nil
        self.lastMessage = dictionary[.lastMessage] as? String ?? ""
        let creationInterval = dictionary[.creationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationInterval)
        let lastMessageTimestampInterval = dictionary[.lastMessageTimestamp] as? Double ?? 0
        self.lastMessageTimestamp = Date(timeIntervalSince1970: lastMessageTimestampInterval)
        self.membersCount = dictionary[.membersCount] as? Int ?? 0
        self.adminUids = dictionary[.adminUids] as? [String] ?? []
        self.thumbnailUrl = dictionary[.thumbnailUrl] as? String ?? nil
        self.membersUids = dictionary[.membersUids] as? [String] ?? []
        self.members = dictionary[.members] as? [User] ?? []
        self.createdBy = dictionary[.createdBy] as? String ?? ""
    }
}

extension String {
    static let id = "id"
    static let name = "name"
    static let lastMessage = "lastMessage"
    static let creationDate = "creationDate"
    static let lastMessageTimestamp = "lastMessageTimestamp"
    static let membersCount = "membersCount"
    static let adminUids = "adminsUids"
    static let membersUids = "membersUid"
    static let thumbnailUrl = "thumbnailUrl"
    static let members = "members"
    static let createdBy = "createdBy"
    static let lastMessageType = "lastMessageType"
}

extension Channel {
    static let placeholder = Channel(
        id: "1",
        lastMessage: "Hello, how're you?",
        creationDate: Date(),
        lastMessageTimestamp: Date(),
        membersCount: 2,
        adminUids: [],
        membersUids: [],
        members: [],
        createdBy: ""
    )
}
