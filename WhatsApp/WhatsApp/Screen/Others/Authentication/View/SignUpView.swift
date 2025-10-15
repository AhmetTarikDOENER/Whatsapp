import SwiftUI

struct SignUpView: View {
    
    //  MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            AuthHeaderView()
            
            AuthTextField(text: .constant(""), type: .email)
            
            let usernameType = AuthTextField.InputType.custom("Username", "at")
            AuthTextField(text: .constant(""), type: usernameType)
            
            AuthTextField(text: .constant(""), type: .password)
            
            AuthButton(title: "Create an Account") {
                
            }
            
            Spacer()
            
            backButton()
                .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.green.opacity(0.8), .teal],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    //  MARK: - Private
    private func backButton() -> some View {
        Button {
            
        } label: {
            HStack {
                Image(systemName: "sparkles")
                
                Text("Already created an account? ") +
                Text("Login").bold()
                
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SignUpView()
}
