import SwiftUI

struct ChatroomView: View {
    
    //  MARK: - Body
    var body: some View {
        MessageListView()
            .toolbar {
                makeLeadingNavigationItems()
                makeTrailingNavigationGroupItems()
            }
            .toolbar(.hidden, for: .tabBar)
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
