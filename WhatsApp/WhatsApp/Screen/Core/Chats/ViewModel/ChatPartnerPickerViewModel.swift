import Foundation

enum ChannelCreationRoute {
    case groupPartnerPicker
    case setupGroupChat
}

enum ChannelConstants {
    static let maxGroupParticipants = 12
}

@MainActor
final class ChatPartnerPickerViewModel: ObservableObject {
    
    //  MARK: - Properties
    @Published var navigationStack = [ChannelCreationRoute]()
    @Published var selectedChatPartners = [User]()
    @Published private(set) var users = [User]()
    private var lastCursor: String?
    
    var showSelectedUsers: Bool {
        !selectedChatPartners.isEmpty
    }
    
    var disableNextButton: Bool {
        selectedChatPartners.isEmpty
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
            self.users = userNode.users
            self.lastCursor = userNode.currentCursor
            print("lastCursor: \(String(describing: lastCursor))")
        } catch {
            print("Failed to fetch users in ChatPartnerPickerViewModel")
        }
    }
}
