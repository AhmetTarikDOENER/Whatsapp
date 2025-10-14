import SwiftUI

private struct StatusSectionHeader: View {
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.dashed")
                .foregroundStyle(.blue)
                .imageScale(.large)
            
            VStack {
                Text("Use status to share photos, text and videos that disappear in 24 hours.") + Text("\n")
                + Text("Status privacy")
                    .foregroundStyle(.blue).bold()
            }
            .padding(.horizontal)
            
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
        }
    }
}

struct UpdatesTabView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                StatusSectionHeader()
            }
            .navigationTitle("Updates")
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    UpdatesTabView()
}
