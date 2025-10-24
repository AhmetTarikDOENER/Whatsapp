import Foundation
import UIKit
import FirebaseStorage

typealias UploadCompletion = (Result<URL, Error>) -> Void
typealias ProgressHandler = (Double) -> Void

enum UploadError: Error {
    case failedToUploadImage(_ description: String)
    case failedToUploadFile(_ description: String)
}

extension UploadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToUploadImage(let description), .failedToUploadFile(let description):
            return description
        }
    }
}

struct FirebaseHelper {
    
    /// For profile images, thumbnails, channel avatars.
    static func uploadImage(
        _ image: UIImage,
        for type: UploadType,
        completion: @escaping UploadCompletion,
        progressHandler: @escaping ProgressHandler
    ) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let storageReference = type.filePath
        let uploadTask = storageReference.putData(imageData) { _, error in
            if let error = error {
                print("Failed to upload image to storage")
                completion(.failure(UploadError.failedToUploadImage(error.localizedDescription)))
                return
            }
            
            storageReference.downloadURL(completion: completion)
        }
        
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentage = Double(progress.completedUnitCount / progress.totalUnitCount)
            progressHandler(percentage)
        }
    }
    
    /// Responsible for uploading both video and audio files.
    static func uploadFile(
        for type: UploadType,
        fileURL: URL,
        completion: @escaping UploadCompletion,
        progressHandler: @escaping ProgressHandler
    ) {
        let storageReference = type.filePath
        let uploadTask = storageReference.putFile(from: fileURL) { _, error in
            if let error = error {
                print("Failed to upload file to storage.")
                completion(.failure(UploadError.failedToUploadFile(error.localizedDescription)))
                return
            }
            
            storageReference.downloadURL(completion: completion)
        }
        
        uploadTask.observe(.progress) { snaphot in
            guard let progress = snaphot.progress else { return }
            let percentage = Double(progress.completedUnitCount / progress.totalUnitCount)
            progressHandler(percentage)
        }
    }
}

extension FirebaseHelper {
    
    enum UploadType {
        case profileImage
        case photoMessage
        case videoMessage
        case audioMessage
        
        var filePath: StorageReference {
            let fileName = UUID().uuidString
            switch self {
            case .profileImage:
                return FirebaseConstants.StorageReference.child("profile_image_urls").child(fileName)
            case .photoMessage:
                return FirebaseConstants.StorageReference.child("photo_messages").child(fileName)
            case .videoMessage:
                return FirebaseConstants.StorageReference.child("video_messages").child(fileName)
            case .audioMessage:
                return FirebaseConstants.StorageReference.child("audio_messages").child(fileName)
            }
        }
    }
}
