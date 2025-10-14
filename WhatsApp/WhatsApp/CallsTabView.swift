import SwiftUI

struct CallsTabView: View {
    
    @State private var searchText = ""
    @State private var callHistoryOption: CallHistoryOption = .all
    
    var body: some View {
        NavigationStack {
            List {
                
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
