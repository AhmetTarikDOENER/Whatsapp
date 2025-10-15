import SwiftUI

struct AuthButton: View {
    
    //  MARK: - Properties
    let title: String
    let onTap: () -> Void
    @Environment(\.isEnabled) private var isEnabled
    
    private var backgroundColor: Color {
        isEnabled ? .white : .white.opacity(0.3)
    }
    
    private var textColor: Color {
        isEnabled ? .green : .white
    }
    
    //  MARK: - Body
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Text(title)
                
                Image(systemName: "arrow.right")
            }
            .font(.headline)
            .foregroundStyle(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .green.opacity(0.2), radius: 12)
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    ZStack {
        Color.teal
        AuthButton(title: "Login") {
            
        }
    }
}
