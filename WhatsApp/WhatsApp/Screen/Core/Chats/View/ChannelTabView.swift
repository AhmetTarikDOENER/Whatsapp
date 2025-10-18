import SwiftUI

struct ChannelTabView: View {
    
    @State private var searchText = ""
    @StateObject private var viewModel = ChannelTabViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                archivedButton()
                
                ForEach(0 ..< 5, id: \.self) { _ in
                    NavigationLink {
                        ChatroomView()
                    } label: {
                        ChannelItemView()
                    }
                }
                
                makeInboxFooterView()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Chats")
            .searchable(text: $searchText)
            .toolbar {
                leadingNavigationItem()
                trailingNavigationItem()
            }
            .sheet(isPresented: $viewModel.showChatPartnerPickerView) {
                ChatPartnerPickerView(onCreate: viewModel.onNewChannelCreated)
            }
            .navigationDestination(isPresented: $viewModel.navigateToChatroom) {
                if let newChannel = viewModel.newCreatedChannel {
                    ChatroomView()
                }
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
            viewModel.showChatPartnerPickerView = true
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
    
    private func archivedButton() -> some View {
        Button {
            
        } label: {
            Label("Archived", systemImage: "archivebox.fill")
                .bold()
                .padding()
                .foregroundStyle(.gray)
        }
    }
    
    private func makeInboxFooterView() -> some View {
        HStack {
            Image(systemName: "lock.fill")
            
            Text("Your personal message are ") +
            Text("end-to-end encrypted")
                .foregroundStyle(.blue)
            
        }
        .foregroundStyle(.gray)
        .font(.caption)
        .padding(.horizontal)
    }
}

#Preview {
    ChannelTabView()
}
