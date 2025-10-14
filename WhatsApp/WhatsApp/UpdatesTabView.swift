import SwiftUI

struct UpdatesTabView: View {
    
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Updates")
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    UpdatesTabView()
}
