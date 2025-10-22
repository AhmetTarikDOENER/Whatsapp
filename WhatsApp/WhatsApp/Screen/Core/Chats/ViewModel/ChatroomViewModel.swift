import Foundation
import Combine

final class ChatroomViewModel: ObservableObject {
    
    @Published var textMessage: String = ""
    @Published var messages: [MessageItem] = []
    private var currentUser: User?
    private var subscriptions = Set<AnyCancellable>()
    private(set) var channel: Channel
    
    init(_ channel: Channel) {
        self.channel = channel
        listenToAuthState()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
    }
    
    private func listenToAuthState() {
        AuthService.shared.authState.receive(on: DispatchQueue.main).sink { [weak self] authState in
            switch authState {
            case .loggedIn(let currentUser):
                self?.currentUser = currentUser
                self?.getAllChannelMembers()
            default:
                break
            }
        }.store(in: &subscriptions)
    }
    
    func sendMessage() {
        guard let currentUser else { return }
        MessageService.sendTextMessage(
            to: channel,
            from: currentUser,
            textMessage) {
                [weak self] in
                self?.textMessage = ""
                print("MessageService is sending")
            }
    }
    
    private func getMessages() {
        MessageService.getMessages(for: channel) { [weak self] messages in
            self?.messages = messages
            print("messages: \(messages.map { $0.text })")
        }
    }
    
    private func getAllChannelMembers() {
        guard let currentUser else { return }
        let membersAlreadyFetched = channel.members.compactMap { $0.uid }
        var memberUidsToFetch = channel.membersUids.filter { !membersAlreadyFetched.contains($0) }
        memberUidsToFetch = memberUidsToFetch.filter { $0 != currentUser.uid }
        UserService.getUsers(with: memberUidsToFetch) { [weak self] userNode in
            guard let self else { return }
            self.channel.members.append(contentsOf: userNode.users)
            self.channel.members.append(currentUser)
            self.getMessages()
            print("getAllChannelMembers: \(channel.members.map { $0.username })")
        }
    }
}
