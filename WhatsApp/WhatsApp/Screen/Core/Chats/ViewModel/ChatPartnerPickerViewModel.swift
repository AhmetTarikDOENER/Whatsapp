import Foundation
import FirebaseAuth

enum ChannelCreationRoute {
    case groupPartnerPicker
    case setupGroupChat
}

enum ChannelConstants {
    static let maxGroupParticipants = 12
}

enum ChannelCreationError: Error {
    case noChatPartners
    case failedToCreateUniqueIds
}

@MainActor
final class ChatPartnerPickerViewModel: ObservableObject {
    
    //  MARK: - Properties
    @Published var navigationStack = [ChannelCreationRoute]()
    @Published var selectedChatPartners = [User]()
    @Published private(set) var users = [User]()
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Oh, something went wrong")
    private var lastCursor: String?
    
    var showSelectedUsers: Bool {
        !selectedChatPartners.isEmpty
    }
    
    var disableNextButton: Bool {
        selectedChatPartners.isEmpty
    }
    
    var isPaginatable: Bool {
        !users.isEmpty
    }
    
    private var isDirectChannel: Bool {
        selectedChatPartners.count == 1
    }
    
    init() {
        Task { await fetchUser() }
    }
    
    //  MARK: - Internal
    func handleItemSelection(_ user: User) {
        if isUserSelected(user) {
            guard let index = selectedChatPartners.firstIndex(where: { $0.uid == user.uid }) else { return }
            selectedChatPartners.remove(at: index)
        } else {
            guard selectedChatPartners.count < ChannelConstants.maxGroupParticipants else {
                let errorMessage = "Sorry, we only allow a maximum of \(ChannelConstants.maxGroupParticipants) participants in a group chat."
                showError(errorMessage)
                return
            }
            selectedChatPartners.append(user)
        }
    }
    
    func isUserSelected(_ user: User) -> Bool {
        let isSelected = selectedChatPartners.contains { $0.uid == user.uid }
        return isSelected
    }
    
    func fetchUser() async {
        do {
            let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 5)
            var fetchedUsers = userNode.users
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            fetchedUsers = fetchedUsers.filter { $0.uid != currentUid }
            self.users.append(contentsOf: fetchedUsers)
            self.lastCursor = userNode.currentCursor
            
        } catch {
            print("Failed to fetch users in ChatPartnerPickerViewModel")
        }
    }
    
    private func createChannel(_ channelName: String?) -> Result<Channel, Error> {
        guard !selectedChatPartners.isEmpty else { return .failure(ChannelCreationError.noChatPartners)}
        guard let channelId = FirebaseConstants.ChannelsReference.childByAutoId().key,
              let currentUid = Auth.auth().currentUser?.uid,
              let messageId = FirebaseConstants.MessagesReference.childByAutoId().key else {
            return .failure(ChannelCreationError.failedToCreateUniqueIds)
        }
        
        var membersUids = selectedChatPartners.compactMap { $0.uid }
        membersUids.append(currentUid)
        let timestamp = Date().timeIntervalSince1970
        
        let newChannelBroadcast = AdminMessageType.channelCreation.rawValue
        
        var channelDictionary: [String: Any] = [
            .id: channelId,
            .lastMessage: newChannelBroadcast,
            .creationDate: timestamp,
            .lastMessageTimestamp: timestamp,
            .membersUids: membersUids,
            .membersCount: membersUids.count,
            .adminUids: [currentUid],
            .createdBy: currentUid
        ]
        
        if let channelName = channelName, channelName.isEmptyOrWhitespace {
            channelDictionary[.name] = channelName
        }
        
        let messageDictionary: [String: Any] = [
            .type: newChannelBroadcast,
            .timestamp: timestamp,
            .ownerUid: currentUid
        ]
        
        FirebaseConstants.ChannelsReference.child(channelId).setValue(channelDictionary)
        FirebaseConstants.MessagesReference.child(channelId).child(messageId).setValue(messageDictionary)
        
        membersUids.forEach { userId in
            /// Which channel is user belongs to, regardless of  whether the direct or group channel
            FirebaseConstants.UserChannelsReference.child(currentUid).child(channelId).setValue(true)
        }
        /// Make sure that a direct channel is unique
        if isDirectChannel {
            let chatPartner = selectedChatPartners[0]
            FirebaseConstants.UserDirectChannels.child(currentUid).child(chatPartner.uid).setValue([channelId: true])
            FirebaseConstants.UserDirectChannels.child(chatPartner.uid).child(currentUid).setValue([channelId: true])
        }
        
        var newChannel = Channel(channelDictionary)
        newChannel.members = selectedChatPartners
        
        return .success(newChannel)
    }
    
    func createDirectChannel(_ chatPartner: User, completion: @escaping (_ newChannel: Channel) -> Void) {
        selectedChatPartners.append(chatPartner)
        let channelCreation = createChannel(nil)
        switch channelCreation {
        case .success(let channel):
            completion(channel)
        case .failure(let error):
            showError("Sorry, something went wrong while we we trying to setup your chat.")
            print("Failed to create a direct channel: \(error.localizedDescription)")
        }
    }
    
    private func showError(_ errorMessage: String) {
        errorState.errorMessage = errorMessage
        errorState.showError = true
    }
    
    func createGroupChannel(_ groupName: String?, completion: @escaping (_ newChannel: Channel) -> Void) {
        let channelCreation = createChannel(groupName)
        switch channelCreation {
        case .success(let channel):
            completion(channel)
        case .failure(let error):
            showError("Sorry, something went wrong while we we trying to setup your group chat.")
            print("Failed to create a group channel: \(error.localizedDescription)")
        }
    }
    
    func deselectAllChatPartners() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.selectedChatPartners.removeAll()
        }
    }
}
