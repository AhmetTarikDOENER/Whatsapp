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
                
                AuthButton(title: "Login in now") {
                    
                }
                
                Spacer()
                
                signupButton()
                    .padding(.bottom, 32)
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
    
    private func signupButton() -> some View {
        NavigationLink {
            Text("Sign up view placeholder")
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
