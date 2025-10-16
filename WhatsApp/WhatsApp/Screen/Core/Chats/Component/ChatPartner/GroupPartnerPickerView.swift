import SwiftUI

struct GroupPartnerPickerView: View {
    
    //  MARK: - Properties
    @State private var searchText = ""
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    
    //  MARK: - Body
    var body: some View {
        List {
            if viewModel.showSelectedUsers {
                SelectedChatPartnerView(users: viewModel.selectedChatPartners)
            }
            
            Section {
                ForEach(User.placeholders) { user in
                    Button {
                        viewModel.handleItemSelection(user)
                    } label: {
                        chatPartnerRowView(user)
                    }
                }
            }
        }
        .animation(.easeInOut, value: viewModel.showSelectedUsers)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search member"
        )
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
}

#Preview {
    NavigationStack {
        GroupPartnerPickerView(viewModel: .init())
    }
}
