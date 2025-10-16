import SwiftUI

enum ChatPartnerPickerOption: String, CaseIterable, Identifiable {
    case newGroup = "New Group"
    case newContact = "New Contact"
    case newComminity = "New Community"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var imageName: String {
        switch self {
        case .newGroup: return "person.2.fill"
        case .newContact: return "person.fill.badge.plus"
        case .newComminity: return "person.3.fill"
        }
    }
}

struct ChatPartnerPickerView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(ChatPartnerPickerOption.allCases) { item in
                    ChatPartnerHeaderItemView(item: item)
                }
            }
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//  MARK: - ChatPartnerPickerView
extension ChatPartnerPickerView {
    
    //  MARK: - ChatPartnerHeaderItemView
    private struct ChatPartnerHeaderItemView: View {
        
        let item: ChatPartnerPickerOption
        
        var body: some View {
            Button {
                
            } label: {
                makeButton()
            }
        }
        
        //  MARK: - Private
        private func makeButton() -> some View {
            HStack {
                Image(systemName: item.imageName)
                    .font(.footnote)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    ChatPartnerPickerView()
}
