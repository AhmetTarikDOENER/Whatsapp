import SwiftUI

struct NewGroupSetupView: View {
    
    @State private var channelName = ""
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    var onCreate: (_ newChannel: Channel) -> Void
    
    var body: some View {
        List {
            Section {
                groupChatSetupHeaderView()
            }
            
            Section {
                Text("Disappearing Messages")
                
                Text("Group Permissions")
            }
            
            Section {
                SelectedChatPartnerView(users: viewModel.selectedChatPartners) { user in
                    viewModel.handleItemSelection(user)
                }
            } header: {
                let maxCount = ChannelConstants.maxGroupParticipants
                let participantsCount = viewModel.selectedChatPartners.count
                Text("Participants: \(participantsCount) of \(maxCount)")
                    .bold()
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("New Group")
        .toolbar {
            trailingNavigationItem()
        }
    }
    
    private func profileImageView() -> some View {
        Button {
            
        } label: {
            ZStack {
                Image(systemName: "camera.fill")
            }
            .frame(width: 60, height: 60)
            .background(Color(.systemGray5))
            .clipShape(Circle())
        }
    }
    
    private func groupChatSetupHeaderView() -> some View {
        HStack {
            profileImageView()
            
            TextField("", text: $channelName, prompt: Text("Group Name (optional)"))
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavigationItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Create") {
                viewModel.createGroupChannel(channelName, completion: onCreate)
            }
            .bold()
            .disabled(viewModel.disableNextButton)
        }
    }
}

#Preview {
    NavigationStack {
        NewGroupSetupView(viewModel: .init()) { newChannel in
            
        }
    }
}
