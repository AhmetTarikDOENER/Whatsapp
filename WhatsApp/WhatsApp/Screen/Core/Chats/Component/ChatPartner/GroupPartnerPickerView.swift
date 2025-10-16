import SwiftUI

struct GroupPartnerPickerView: View {
    
    //  MARK: - Properties
    @State private var searchText = ""
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    
    //  MARK: - Body
    var body: some View {
        List {
            if viewModel.showSelectedUsers {
                SelectedChatPartnerView(users: viewModel.selectedChatPartners) { user in
                    withAnimation(.spring) {
                        viewModel.handleItemSelection(user)
                    }
                }
            }
            
            Section {
                ForEach(viewModel.users) { user in
                    Button {
                        viewModel.handleItemSelection(user)
                    } label: {
                        chatPartnerRowView(user)
                    }
                }
            }
            
            if viewModel.isPaginatable {
                loadMoreUsersView()
            }
        }
        .animation(.easeInOut, value: viewModel.showSelectedUsers)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search member"
        )
        .toolbar {
            titleView()
            trailingNavigationItem()
        }
    }
    
    private func chatPartnerRowView(_ user: User) -> some View {
        ChatPartnerRowView(user: user) {
            Spacer()
            let isSelected = viewModel.isUserSelected(user)
            let imageName = isSelected ? "checkmark.circle.fill" : "circle"
            let foregroundStyle = isSelected ? Color.blue : Color(.systemGray4)
            Image(systemName: imageName)
                .foregroundStyle(foregroundStyle)
                .imageScale(.large)
        }
    }
    
    private func loadMoreUsersView() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUser()
            }
    }
}

extension GroupPartnerPickerView {
    @ToolbarContentBuilder
    private func titleView() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack {
                Text("Add Participants")
                    .bold()
                
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelConstants.maxGroupParticipants
                
                Text("\(count)/\(maxCount)")
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavigationItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Next") {
                viewModel.navigationStack.append(.setupGroupChat)
            }
            .bold()
            .disabled(viewModel.disableNextButton)
        }
    }
}

#Preview {
    NavigationStack {
        GroupPartnerPickerView(viewModel: .init())
    }
}
