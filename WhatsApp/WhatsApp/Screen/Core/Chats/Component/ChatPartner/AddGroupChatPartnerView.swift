import SwiftUI

struct AddGroupChatPartnerView: View {
    
    //  MARK: - Properties
    @State private var searchText = ""
    
    //  MARK: - Body
    var body: some View {
        List {
            Text("PLACEHOLDER")
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search member"
        )
    }
}

#Preview {
    NavigationStack {
        AddGroupChatPartnerView()
    }
}
