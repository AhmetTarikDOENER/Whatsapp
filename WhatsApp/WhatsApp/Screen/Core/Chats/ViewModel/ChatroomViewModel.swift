import Foundation
import Combine
import PhotosUI
import SwiftUI
import AVKit

final class ChatroomViewModel: ObservableObject {
    
    @Published var textMessage: String = ""
    @Published var messages: [MessageItem] = []
    private var currentUser: User?
    private var subscriptions = Set<AnyCancellable>()
    private(set) var channel: Channel
    @Published var showPhotoPicker = false
    @Published var photoPickerItems: [PhotosPickerItem] = []
    @Published var mediaAttachments: [MediaAttachment] = []
    @Published var videoPlayerState: (show: Bool, player: AVPlayer?) = (false, nil)
    @Published var isRecordingAudioMessage = false
    @Published var elapsedAudioMessageTime: TimeInterval = 0
    @Published var scrollToBottomRequest: (scroll: Bool, isAnimated: Bool) = (false, false)
    private let audioRecorderService = AudioRecorderService()
    
    var showPhotoPickerPreview: Bool {
        !mediaAttachments.isEmpty || !photoPickerItems.isEmpty
    }
    
    var disableSendButton: Bool {
        mediaAttachments.isEmpty && textMessage.isEmpty
    }
    
    init(_ channel: Channel) {
        self.channel = channel
        listenToAuthState()
        onPhotoPickerSelection()
        setupAudioRecorderListeners()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
        audioRecorderService.tearDown()
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
    
    private func setupAudioRecorderListeners() {
        audioRecorderService.$isRecording.receive(on: DispatchQueue.main)
            .sink { [weak self] isRecording in
                self?.isRecordingAudioMessage = isRecording
            }.store(in: &subscriptions)
        
        audioRecorderService.$elapsedTime.receive(on: DispatchQueue.main)
            .sink { [weak self] elapsedTime in
                self?.elapsedAudioMessageTime = elapsedTime
            }.store(in: &subscriptions)
    }
    
    func sendMessage() {
        guard let currentUser else { return }
        if mediaAttachments.isEmpty {
            MessageService.sendTextMessage(to: channel, from: currentUser, textMessage) { [weak self] in
                self?.textMessage = ""
            }
        } else {
            sendMultipleMediaMessages(textMessage, attachments: mediaAttachments)
            clearTextInputArea()
        }
    }
    
    private func clearTextInputArea() {
        mediaAttachments.removeAll()
        photoPickerItems.removeAll()
        textMessage = ""
        UIApplication.dismissKeyboard()
    }
    
    private func sendMultipleMediaMessages(_ text: String, attachments: [MediaAttachment]) {
        mediaAttachments.forEach { attachment in
            switch attachment.type {
            case .photo:
                sendPhotoMessage(text: text, attachment)
            case .video:
                sendVideoMessage(text: text, attachment)
            case .audio:
                sendAudioMessage(text: text, attachment)
            }
        }
    }

    private func sendPhotoMessage(text: String, _ attachment: MediaAttachment) {
        uploadImageToStorage(attachment) { [weak self] imageURL in
            guard let self, let currentUser else { return }
            let uploadParameters = MessageUploadParameters(
                channel: channel,
                text: text,
                type: .photo,
                attachment: attachment,
                thumbnailURL: imageURL.absoluteString,
                sender: currentUser,
            )
            
            MessageService.sendMediaMessage(to: channel, parameters: uploadParameters) {
                self.scrollToBottom(isAnimated: true)
            }
        }
    }
    
    private func scrollToBottom(isAnimated: Bool) {
        scrollToBottomRequest.scroll = true
        scrollToBottomRequest.isAnimated = isAnimated
    }
    
    private func uploadImageToStorage(_ attachement: MediaAttachment, completion: @escaping(_ imageURL: URL) -> Void) {
        FirebaseHelper.uploadImage(attachement.thumbnail, for: .photoMessage) { result in
            switch result {
            case .success(let imageURL):
                completion(imageURL)
            case .failure(let error):
                print("Failed to upload image to storage: \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("UPLOAD IMAGE PROGRESS: \(progress)")
        }
    }
    
    private func sendVideoMessage(text: String, _ attachment: MediaAttachment) {
        ///Uploads the video file to storage bucket
        uploadFileToStorage(for: .videoMessage, attachment) { [weak self] videoURL in
            /// Upload the video thumbnail
            self?.uploadImageToStorage(attachment) { thumbnailURL in
                guard let self = self, let currentUser = self.currentUser else { return }
                let uploadParameter = MessageUploadParameters(
                    channel: self.channel,
                    text: text,
                    type: .video,
                    attachment: attachment,
                    thumbnailURL: thumbnailURL.absoluteString,
                    videoUrl: videoURL.absoluteString,
                    sender: currentUser
                )
                
                /// Save metadatas and urls to database
                MessageService.sendMediaMessage(to: self.channel, parameters: uploadParameter) { [weak self] in
                    self?.scrollToBottom(isAnimated: true)
                }
            }
        }
    }
    
    private func uploadFileToStorage(
        for uploadType: FirebaseHelper.UploadType,
        _ attachement: MediaAttachment,
        completion: @escaping(_ fileURL: URL) -> Void
    ) {
        guard let fileToUpload = attachement.fileURL else { return }
        FirebaseHelper.uploadFile(for: uploadType, fileURL: fileToUpload) { result in
            switch result {
            case .success(let fileURL):
                completion(fileURL)
            case .failure(let error):
                print("Failed to upload file to storage: \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("UPLOAD FILE PROGRESS: \(progress)")
        }
    }
    
    private func sendAudioMessage(text: String, _ attachment: MediaAttachment) {
        ///Uploads the audio file to storage bucket
        guard let audioDuration = attachment.audioDuration, let currentUser else { return }
        uploadFileToStorage(for: .audioMessage, attachment) { [weak self] fileURL in
            guard let self else { return }
            let uploadParameter = MessageUploadParameters(
                channel: self.channel,
                text: text,
                type: .audio,
                attachment: attachment,
                sender: currentUser,
                audioURL: fileURL.absoluteString,
                audioDuration: audioDuration
            )
            
            MessageService.sendMediaMessage(to: self.channel, parameters: uploadParameter) {
                self.scrollToBottom(isAnimated: true)
            }
        }
    }
    
    private func getMessages() {
        MessageService.getMessages(for: channel) { [weak self] messages in
            self?.messages = messages
            self?.scrollToBottom(isAnimated: false)
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
        case .recordAudio:
            toggleAudioRecording()
        }
    }
    
    func toggleAudioRecording() {
        if audioRecorderService.isRecording {
            audioRecorderService.stopRecording { [weak self] audioURL, audioDuration in
                self?.createAudioAttachment(from: audioURL, audioDuration: audioDuration)
            }
        } else {
            audioRecorderService.startRecording()
        }
    }
    
    private func createAudioAttachment(from audioURL: URL?, audioDuration: TimeInterval) {
        guard let audioURL else { return }
        let id = UUID().uuidString
        let audioAttachment = MediaAttachment(id: id, type: .audio(audioURL, audioDuration))
        mediaAttachments.insert(audioAttachment, at: 0)
    }
    
    private func onPhotoPickerSelection() {
        $photoPickerItems.sink { [weak self] photoItems in
            guard let self else { return }
            let audioRecordings = mediaAttachments.filter({ $0.type == .audio(.stubUrl, .stubTimeInterval) })
            self.mediaAttachments = audioRecordings
            Task { await self.parsePhotoPickerItems(photoItems) }
        }.store(in: &subscriptions)
    }
    
    @MainActor
    private func parsePhotoPickerItems(_ photoPickerItems: [PhotosPickerItem]) async {
        for photoItem in photoPickerItems {
            if photoItem.isVideo {
                if let movie = try? await photoItem.loadTransferable(type: VideoPickerTransferable.self),
                   let thumbnail = try? await movie.url.generateVideoThumbnail(),
                   let itemIdentifier = photoItem.itemIdentifier {
                    let videoAttachment = MediaAttachment(id: itemIdentifier, type: .video(thumbnail, movie.url))
                    self.mediaAttachments.insert(videoAttachment, at: 0)
                }
            } else {
                guard let data = try? await photoItem.loadTransferable(type: Data.self),
                      let thumbnailImage = UIImage(data: data),
                      let itemIdentifier = photoItem.itemIdentifier else { return }
                let photoAttachment = MediaAttachment(id: itemIdentifier, type: .photo(thumbnailImage))
                self.mediaAttachments.insert(photoAttachment, at: 0)
            }
        }
    }
    
    func dismissMediaPlayer() {
        videoPlayerState.player?.replaceCurrentItem(with: nil)
        videoPlayerState.player = nil
        videoPlayerState.show = false
    }
    
    func showMediaPlayer(_ fileURL: URL) {
        videoPlayerState.show = true
        videoPlayerState.player = AVPlayer(url: fileURL)
    }
    
    func handleMediaAttachmentPreview(_ action: MediaAttachmentPreview.UserAction) {
        switch action {
        case .play(let attachment):
            guard let fileURL = attachment.fileURL else { return }
            showMediaPlayer(fileURL)
        case .removeItem(let attachment):
            remove(attachment)
            guard let fileURL = attachment.fileURL else { return }
            if attachment.type == .audio(.stubUrl, .stubTimeInterval) {
                audioRecorderService.deleteRecording(at: fileURL)
            }
        }
    }
    
    private func remove(_ item: MediaAttachment) {
        guard let attachmentIndex = mediaAttachments.firstIndex(where: { $0.id == item.id }) else { return }
        mediaAttachments.remove(at: attachmentIndex)
        guard let photoIndex = photoPickerItems.firstIndex(where: { $0.itemIdentifier == item.id }) else { return }
        photoPickerItems.remove(at: photoIndex)
    }
}
