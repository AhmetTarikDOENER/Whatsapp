import SwiftUI

struct AddGroupChatPartnerView: View {
    
    //  MARK: - Properties
    @State private var searchText = ""
    
    //  MARK: - Body
    var body: some View {
        List {
            Section {
                ForEach(0 ..< 11) { _ in
                    chatPartnerRowView(.placeholderUser)
                }
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search member"
        )
    }
    
    private func chatPartnerRowView(_ user: User) -> some View {
        ChatPartnerRowView(user: .placeholderUser) {
            Spacer()
            Image(systemName: "circle")
                .foregroundStyle(Color(.systemGray4))
                .imageScale(.large)
        }
    }
}

#Preview {
    NavigationStack {
        AddGroupChatPartnerView()
    }
}
