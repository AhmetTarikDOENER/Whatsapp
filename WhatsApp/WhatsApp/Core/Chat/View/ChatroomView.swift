import SwiftUI

struct ChatroomView: View {
    
    //  MARK: - Body
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0 ..< 12) { _ in
                    Text("PLACEHOLDER")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color.gray.opacity(0.1))
                }
            }
        }
        .toolbar {
            makeLeadingNavigationItems()
            makeTrailingNavigationGroupItems()
        }
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
    }
}

//  MARK: - ChatroomView+Extension
extension ChatroomView {
    @ToolbarContentBuilder
    private func makeLeadingNavigationItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                Circle()
                    .frame(width: 35, height: 35)
                
                Text("johndoe")
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func makeTrailingNavigationGroupItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            makeVideoCallButton()
            makeVoiceCallButton()
        }
    }
    
    private func makeVideoCallButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "video")
        }
    }
    
    private func makeVoiceCallButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "phone")
        }
    }
}

#Preview {
    NavigationStack {
        ChatroomView()
    }
}
