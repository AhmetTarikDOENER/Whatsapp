import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                AuthHeaderView()
                
                AuthTextField(text: .constant(""), type: .email)
                AuthTextField(text: .constant(""), type: .password)
                
                forgotPasswordButton()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.teal.gradient)
            .ignoresSafeArea()
        }
    }
    
    private func forgotPasswordButton() -> some View {
        Button {
            
        } label: {
            Text("Forgot password?")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 32)
                .bold()
                .padding(.vertical)
        }
    }
}

#Preview {
    LoginView()
}
