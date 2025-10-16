import SwiftUI

struct AddGroupChatPartnerView: View {
    
    //  MARK: - Properties
    @State private var searchText = ""
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    
    //  MARK: - Body
    var body: some View {
        List {
            if viewModel.showSelectedUsers {
                Text("Users selected")
            }
            
            Section {
                ForEach([User.placeholderUser]) { user in
                    Button {
                        viewModel.handleItemSelection(user)
                    } label: {
                        chatPartnerRowView(.placeholderUser)
                    }
                }
            }
        }
        .animation(.easeIn, value: viewModel.showSelectedUsers)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search member"
        )
    }
    
    private func chatPartnerRowView(_ user: User) -> some View {
        ChatPartnerRowView(user: .placeholderUser) {
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
        AddGroupChatPartnerView(viewModel: .init())
    }
}
