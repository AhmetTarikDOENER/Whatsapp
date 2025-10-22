import SwiftUI

struct MediaAttachmentPreview: View {
    
    let selectedPhotos: [UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                audioAttachmentPreview()
                ForEach(selectedPhotos, id: \.self) { image in
                    thumbnailImageView()
                }
            }
        }
        .frame(height: Constants.listHeight)
        .frame(maxWidth: .infinity)
        .background(.whatsAppWhite)
    }
    
    private func thumbnailImageView() -> some View {
        Button {
            
        } label: {
            Image(.stubImage0)
                .resizable()
                .scaledToFill()
                .frame(width: Constants.imageDimension, height: Constants.imageDimension)
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .clipped()
                .overlay(alignment: .topTrailing) {
                    cancelButton()
                }
                .overlay(alignment: .center) {
                    playButton("play.fill")
                }
        }
    }
    
    private func cancelButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "xmark")
                .scaledToFit()
                .imageScale(.small)
                .padding(4)
                .foregroundStyle(.white)
                .background(.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(2)
                .bold()
        }
    }
    
    private func playButton(_ systemName: String) -> some View {
        Button {
            
        } label: {
            Image(systemName: systemName)
                .scaledToFit()
                .imageScale(.large)
                .padding(10)
                .foregroundStyle(.white)
                .background(.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(10)
                .bold()
        }
    }
    
    private func audioAttachmentPreview() -> some View {
        ZStack {
            LinearGradient(colors: [.green, .green.opacity(0.7), .teal], startPoint: .topLeading, endPoint: .bottom)
            playButton("mic.fill")
                .padding(.bottom, 16)
        }
        .frame(width: Constants.imageDimension * 2, height: Constants.imageDimension)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .clipped()
        .overlay(alignment: .topTrailing) {
            cancelButton()
        }
        .overlay(alignment: .bottom) {
            Text("Test mp3 file name here")
                .lineLimit(1)
                .font(.caption)
                .padding(2)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(.white)
                .background(.white.opacity(0.4))
        }
    }
}

extension MediaAttachmentPreview {
    enum Constants {
        static let listHeight: CGFloat = 100
        static let imageDimension: CGFloat = 80
    }
}

#Preview {
    MediaAttachmentPreview(selectedPhotos: [])
}
