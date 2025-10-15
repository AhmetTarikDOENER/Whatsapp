import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    
    //  MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            AuthHeaderView()
            
            AuthTextField(text: $authViewModel.email, type: .email)
            
            let usernameType = AuthTextField.InputType.custom("Username", "at")
            AuthTextField(text: $authViewModel.username, type: usernameType)
            
            AuthTextField(text: $authViewModel.password, type: .password)
            
            AuthButton(title: "Create an Account") {
                
            }
            .disabled(authViewModel.disableSignUpButton)
            
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
            dismiss()
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
    SignUpView(authViewModel: .init())
}
