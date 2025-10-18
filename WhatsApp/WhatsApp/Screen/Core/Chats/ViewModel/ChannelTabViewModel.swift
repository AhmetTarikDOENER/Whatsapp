import SwiftUI

final class ChannelTabViewModel: ObservableObject {
    
    @Published var navigateToChatroom = false
    @Published var newCreatedChannel: Channel?
    @Published var showChatPartnerPickerView: Bool = false
    
    func onNewChannelCreated(_ channel: Channel) {
        showChatPartnerPickerView = false
        newCreatedChannel = channel
        navigateToChatroom = true
    }
}
