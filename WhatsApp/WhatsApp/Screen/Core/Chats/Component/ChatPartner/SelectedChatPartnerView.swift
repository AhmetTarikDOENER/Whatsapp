import SwiftUI

struct SelectedChatPartnerView: View {
    
    let users: [User]
    let onTapHandler: (_ user: User) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(users) { user in
                    chatPartnerView(user)
                }
            }
        }
    }
    
    private func chatPartnerView(_ user: User) -> some View {
        VStack {
            Circle()
                .fill(Color(.systemGray4))
                .frame(width: 60, height: 60)
                .overlay(alignment: .topTrailing) {
                    cancelButton(user)
                }
            
            Text(user.username)
        }
    }
    
    private func cancelButton(_ user: User) -> some View {
        Button {
            onTapHandler(user)
        } label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .padding(4)
                .background(Color(.systemGray2))
                .clipShape(Circle())
        }
    }
}

#Preview {
    SelectedChatPartnerView(users: User.placeholders) { user in
        
    }
}
