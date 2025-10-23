import Foundation
import Combine
import PhotosUI
import SwiftUI

final class ChatroomViewModel: ObservableObject {
    
    @Published var textMessage: String = ""
    @Published var messages: [MessageItem] = []
    private var currentUser: User?
    private var subscriptions = Set<AnyCancellable>()
    private(set) var channel: Channel
    @Published var showPhotoPicker = false
    @Published var photoPickerItems: [PhotosPickerItem] = []
    @Published var selectedPhotos: [UIImage] = []
    
    var showPhotoPickerPreview: Bool {
        !photoPickerItems.isEmpty
    }
    
    init(_ channel: Channel) {
        self.channel = channel
        listenToAuthState()
        onPhotoPickerSelection()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
    }
    
    private func listenToAuthState() {
        AuthService.shared.authState.receive(on: DispatchQueue.main).sink { [weak self] authState in
            guard let self else { return }
            switch authState {
            case .loggedIn(let currentUser):
                self.currentUser = currentUser
                if self.channel.allMembersFetched {
                    self.getMessages()
                } else {
                    self.getAllChannelMembers()
                }
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
            self.getMessages()
            print("getAllChannelMembers: \(channel.members.map { $0.username })")
        }
    }
    
    func handleTextInputArea(_ action: TextInputArea.UserAction) {
        switch action {
        case .presentPhotoPicker:
            showPhotoPicker = true
        case .sendMessage:
            sendMessage()
        }
    }
    
    private func onPhotoPickerSelection() {
        $photoPickerItems.sink { [weak self] photoItems in
            guard let self else { return }
            Task { await self.parsePhotoPickerItems(photoItems) }
        }.store(in: &subscriptions)
    }
    
    @MainActor
    private func parsePhotoPickerItems(_ photoPickerItems: [PhotosPickerItem]) async {
        for photoItem in photoPickerItems {
            if photoItem.isVideo {
                
            } else {
                guard let data = try? await photoItem.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { return }
                self.selectedPhotos.insert(uiImage, at: 0)
            }
        }
    }
}
