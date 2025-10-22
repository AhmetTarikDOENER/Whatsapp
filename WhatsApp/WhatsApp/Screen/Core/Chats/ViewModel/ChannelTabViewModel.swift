import SwiftUI
import FirebaseAuth

enum ChannelTabRoutes: Hashable {
    case chatroom(_ channel: Channel)
}

final class ChannelTabViewModel: ObservableObject {
    
    @Published var navigateToChatroom = false
    @Published var newCreatedChannel: Channel?
    @Published var showChatPartnerPickerView: Bool = false
    @Published var channels: [Channel] = []
    typealias ChannelId = String
    @Published var channelDictionary: [ChannelId: Channel] = [:]
    @Published var navigationRoutes = [ChannelTabRoutes]()
    private let currentUser: User
    
    init(_ currentUser: User) {
        self.currentUser = currentUser
        fetchCurrentUserChannels()
    }
    
    func onNewChannelCreated(_ channel: Channel) {
        showChatPartnerPickerView = false
        newCreatedChannel = channel
        navigateToChatroom = true
    }
    
    private func fetchCurrentUserChannels() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.UserChannelsReference.child(currentUid).observe(.value) { [weak self] snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach { key, value in
                let channelId = key
                self?.getChannel(with: channelId)
            }
        } withCancel: { error in
            print("Failed to get current user channelIds: \(error.localizedDescription)")
        }
    }
    
    private func getChannel(with channelId: String) {
        FirebaseConstants.ChannelsReference.child(channelId).observe(.value) { [weak self] snapshot in
            guard let dictionary = snapshot.value as? [String: Any], let self = self else { return }
            var channel = Channel(dictionary)
            self.getChannelMembers(channel) { members in
                channel.members = members
                if channel.isGroupChat == false {
                    channel.members.append(self.currentUser)
                }
                self.channelDictionary[channelId] = channel
                self.reloadData()
            }
            print("channel: \(channel.title)")
        } withCancel: { error in
            print("Failed to get the channel for id \(channelId): \(error.localizedDescription)")
        }
    }
    
    private func getChannelMembers(_ channel: Channel, completion: @escaping (_ members: [User]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let channelMembersUids = Array(channel.membersUids.filter { $0 != currentUid }.prefix(2))
        UserService.getUsers(with: channelMembersUids) { usernode in
            completion(usernode.users)
        }
    }
    
    private func reloadData() {
        self.channels = Array(channelDictionary.values)
        self.channels.sort { $0.lastMessageTimestamp > $1.lastMessageTimestamp }
    }
}
