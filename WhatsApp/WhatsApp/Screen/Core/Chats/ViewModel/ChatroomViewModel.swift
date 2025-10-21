import Foundation
import Combine

final class ChatroomViewModel: ObservableObject {
    
    @Published var textMessage: String = ""
    @Published var currentUser: User?
    private var subscriptions = Set<AnyCancellable>()
    private let channel: Channel
    
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
        AuthService.shared.authState.receive(on: DispatchQueue.main).sink { authState in
            switch authState {
            case .loggedIn(let currentUser):
                self.currentUser = currentUser
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
}
