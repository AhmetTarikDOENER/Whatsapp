import Foundation
import Firebase
import FirebaseDatabase

struct UserService {
    static func paginateUsers(lastCursor: String?, pageSize: UInt) async throws -> UserNode {
        /// Initial data fetch, there is no lastCursor
        if lastCursor == nil {
            let mainSnapshot = try await FirebaseConstants.UserReference.queryLimited(toLast: pageSize).getData()
            guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
                  let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else { return .emptyNode }
            
            let users: [User] = allObjects.compactMap { userSnapshot in
                let userDictionary = userSnapshot.value as? [String: Any] ?? [:]
                return User(dictionary: userDictionary)
            }
            
            if users.count == mainSnapshot.childrenCount {
                let userNode = UserNode(users: users, currentCursor: first.key)
                return userNode
            }
            
            return .emptyNode
        } else {
            /// Paginate more data
            let mainSnapshot = try await FirebaseConstants.UserReference
                .queryOrderedByKey()
                .queryEnding(atValue: lastCursor)
                .queryLimited(toLast: pageSize + 1)
                .getData()
            
            guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
                  let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else { return .emptyNode }
            
            let users: [User] = allObjects.compactMap { userSnapshot in
                let userDictionary = userSnapshot.value as? [String: Any] ?? [:]
                return User(dictionary: userDictionary)
            }
            
            if users.count == mainSnapshot.childrenCount {
                let filteredUsers = users.filter { $0.uid != lastCursor }
                let userNode = UserNode(users: filteredUsers, currentCursor: first.key)
                return userNode
            }
            
            return .emptyNode
        }
    }
}

struct UserNode {
    var users: [User]
    var currentCursor: String?
    static let emptyNode = UserNode(users: [], currentCursor: nil)
}
