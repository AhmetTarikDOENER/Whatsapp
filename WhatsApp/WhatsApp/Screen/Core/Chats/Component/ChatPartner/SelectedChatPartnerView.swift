import SwiftUI

struct SelectedChatPartnerView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(User.placeholders) { user in
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
                    cancelButton()
                }
            
            Text(user.username)
        }
    }
    
    private func cancelButton() -> some View {
        Button {
            
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
    SelectedChatPartnerView()
}
