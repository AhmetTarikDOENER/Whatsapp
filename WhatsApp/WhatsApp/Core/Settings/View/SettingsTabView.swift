import SwiftUI

struct SettingsTabView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Settings")
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    SettingsTabView()
}
