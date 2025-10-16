import Foundation

enum ChannelCreationRoute {
    case addGroupChatMembers
    case setupGroupChat
}

final class ChatPartnerPickerViewModel: ObservableObject {
    
    //  MARK: - Properties
    @Published var navigationStack = [ChannelCreationRoute]()
    @Published var selectedChatPartners = [User]()
    
    var showSelectedUsers: Bool {
        !selectedChatPartners.isEmpty
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
}
