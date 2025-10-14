import SwiftUI

struct ChannelTabView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Chats")
            .searchable(text: $searchText)
            .toolbar {
                leadingNavigationItem()
                trailingNavigationItem()
            }
        }
    }
}

extension ChannelTabView {
    @ToolbarContentBuilder
    private func leadingNavigationItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Button {
                    
                } label: {
                    Label("Select Chats", systemImage: "checkmark.circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavigationItem() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            aiButton()
            cameraButton()
            newChatButton()
        }
    }
    
    private func aiButton() -> some View {
        Button {
            
        } label: {
            Image(.circle)
        }
    }
    
    private func newChatButton() -> some View {
        Button {
            
        } label: {
            Image(.plus)
        }
    }
    
    private func cameraButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "camera")
        }
    }
}

#Preview {
    ChannelTabView()
}
