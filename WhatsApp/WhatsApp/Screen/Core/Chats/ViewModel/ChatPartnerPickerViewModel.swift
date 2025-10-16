import Foundation

enum ChannelCreationRoute {
    case addGroupChatMembers
    case setupGroupChat
}

final class ChatPartnerPickerViewModel: ObservableObject {
    
    @Published var navigationStack = [ChannelCreationRoute]()
    
}
