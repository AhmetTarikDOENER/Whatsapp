import Foundation

struct Channel: Identifiable {
    var id: String
    var name: String?
    var lastMessage: String
    var creationDate: Date
    var lastMessageTimestamp: Date
    var membersCount: UInt
    var adminUids: [String]
    var membersUids: [String]
    var members: [User]
    var thumbnailUrl: String?
    
    var isGroupChat: Bool {
        members.count > 2
    }
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
        members: []
    )
}
