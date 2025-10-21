import SwiftUI

struct ChannelCreationTextView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .gray.opacity(0.2) : .yellow.opacity(0.2)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Text(Image(systemName: "lock.fill")) +
            Text(" Messages and calls end-to-end encrypted, No one outside of this chat, not even WhatsApp, can read or listen to them.") +
            Text(" Learn more.")
                .bold()
        }
        .font(.footnote)
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding(.horizontal, 32)
    }
}

#Preview {
    ChannelCreationTextView()
}
