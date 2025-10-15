import SwiftUI

struct TextInputArea: View {
    
    //  MARK: - Properties
    @State private var text = ""
    
    //  MARK: - Body
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            imagePickerButton()
            audioRecorderButton()
            messageTextField()
            sendMessageButton()
        }
        .padding(.bottom)
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .background(.whatsAppWhite)
    }
    
    //  MARK: - Private
    private func imagePickerButton() -> some View {
        Button {
            
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
        TextField("", text: $text, axis: .vertical)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlay(textViewBorder())
    }
    
    private func sendMessageButton() -> some View {
        Button {
            
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
}

#Preview {
    TextInputArea()
}
