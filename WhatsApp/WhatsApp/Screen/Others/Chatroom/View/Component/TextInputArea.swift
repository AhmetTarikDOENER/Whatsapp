import SwiftUI

struct TextInputArea: View {
    
    //  MARK: - Properties
    @Binding var textMessage: String
    let actionHandler: (_ action: UserAction) -> Void
    @State private var isRecording = false
    
    private var disableSendButton: Bool {
        textMessage.isEmptyOrWhitespace
    }
    
    //  MARK: - Body
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            imagePickerButton()
            audioRecorderButton()
//            messageTextField()
            audioSessionIndicatorView()
            sendMessageButton()
                .disabled(disableSendButton)
                .grayscale(disableSendButton ? 0.8 : 0.0)
        }
        .padding(.bottom)
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .background(.whatsAppWhite)
    }
    
    //  MARK: - Private
    private func imagePickerButton() -> some View {
        Button {
            actionHandler(.presentPhotoPicker)
        } label: {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 22))
        }
    }
    
    private func audioRecorderButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "mic.fill")
                .fontWeight(.heavy)
                .imageScale(.small)
                .foregroundStyle(.white)
                .padding(8)
                .background(.blue)
                .clipShape(Circle())
                .padding(.horizontal, 4)
        }
    }
    
    private func textViewBorder() -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(Color(.systemGray5))
    }
    
    private func messageTextField() -> some View {
        TextField("", text: $textMessage, axis: .vertical)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlay(textViewBorder())
    }
    
    private func sendMessageButton() -> some View {
        Button {
            actionHandler(.sendMessage)
        } label: {
            Image(systemName: "arrow.up")
                .fontWeight(.heavy)
                .imageScale(.small)
                .foregroundStyle(.white)
                .padding(8)
                .background(.blue)
                .clipShape(Circle())
                .padding(.horizontal, 4)
        }
    }
    
    private func audioSessionIndicatorView() -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .foregroundStyle(.red)
                .font(.caption)
            
            Text("Recording audio")
                .font(.callout)
                .lineLimit(1)
            
            Spacer()
            
            Text("00:01")
                .font(.callout)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .frame(height: 30)
        .frame(maxWidth: .infinity)
        .clipShape(Capsule())
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.blue.opacity(0.1))
        )
        .overlay { textViewBorder() }
    }
}

extension TextInputArea {
    enum UserAction {
        case presentPhotoPicker
        case sendMessage
    }
}

#Preview {
    TextInputArea(textMessage: .constant("")) { action in 
        
    }
}
