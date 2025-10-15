import SwiftUI

struct LoginView: View {
    
    //  MARK: - Properties
    @StateObject private var authViewModel = AuthViewModel()
    
    //  MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                AuthHeaderView()
                
                AuthTextField(text: $authViewModel.email, type: .email)
                AuthTextField(text: $authViewModel.password, type: .password)
                
                forgotPasswordButton()
                
                AuthButton(title: "Login in now") {
                    
                }
                .disabled(authViewModel.disableLoginButton)
                
                Spacer()
                
                signupButton()
                    .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.teal.gradient)
            .ignoresSafeArea()
            .alert(isPresented: $authViewModel.errorState.showError) {
                Alert(
                    title: Text(authViewModel.errorState.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    //  MARK: - Private
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
    
    private func signupButton() -> some View {
        NavigationLink {
            SignUpView(authViewModel: authViewModel)
        } label: {
            HStack {
                Image(systemName: "sparkles")
                
                Text("Don't have an account? ") +
                Text("Create one").bold()
                
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoginView()
}
