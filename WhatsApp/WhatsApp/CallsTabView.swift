import SwiftUI

private struct CreateCallLinkSection: View {
    var body: some View {
        HStack {
            Image(systemName: "link")
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(Circle())
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading) {
                Text("Create call link")
                    .foregroundStyle(.blue)
                
                Text("Share a link for your WhatsApp calls.")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
        }
    }
}

private struct RecentCallHistoryItemView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 45, height: 45)
            
            recentsCallTextView()
            
            Spacer()
            
            Text("Yesterday")
                .foregroundStyle(.gray)
                .font(.system(size: 16))
            
            Image(systemName: "info.circle")
        }
    }
    
    private func recentsCallTextView() -> some View {
        VStack(alignment: .leading) {
            Text("John Applause")
            
            HStack(spacing: 4) {
                Image(systemName: "phone.arrow.up.right.fill")
                
                Text("Outgoing")
            }
            .font(.system(size: 14))
            .foregroundStyle(.gray)
        }
    }
}

struct CallsTabView: View {
    
    @State private var searchText = ""
    @State private var callHistoryOption: CallHistoryOption = .all
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    CreateCallLinkSection()
                }
                
                Section {
                    ForEach(0 ..< 11, id: \.self) { _ in
                        RecentCallHistoryItemView()
                    }
                } header: {
                    Text("Recent")
                        .textCase(nil)
                        .font(.headline).bold()
                        .foregroundStyle(.whatsAppBlack)
                }
            }
            .navigationTitle("Calls")
            .searchable(text: $searchText)
            .toolbar {
                leadingNavigationItem()
                trailingNavigationItem()
                principalNavigationBarItem()
            }
        }
    }
}

extension CallsTabView {
    
    private enum CallHistoryOption: String, CaseIterable, Identifiable {
        case all, missed
        
        var id: String {
            return rawValue
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavigationItem() -> some ToolbarContent{
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "phone.arrow.up.right")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func leadingNavigationItem() -> some ToolbarContent{
        ToolbarItem(placement: .topBarLeading) {
            Button("Edit") {  }
        }
    }
    
    @ToolbarContentBuilder
    private func principalNavigationBarItem() -> some ToolbarContent{
        ToolbarItem(placement: .principal) {
            Picker("", selection: $callHistoryOption) {
                ForEach(CallHistoryOption.allCases) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
        }
    }
}

#Preview {
    CallsTabView()
}
