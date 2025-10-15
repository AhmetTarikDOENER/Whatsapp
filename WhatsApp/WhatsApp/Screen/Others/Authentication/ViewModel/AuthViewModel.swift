import Foundation

final class AuthViewModel: ObservableObject {
    
    //  MARK: - Properties
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var isLoading = false
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Uh, Oh Something went wrong!")
    
    var disableLoginButton: Bool {
        email.isEmpty || password.isEmpty || isLoading
    }
    
    var disableSignUpButton: Bool {
        email.isEmpty || password.isEmpty || username.isEmpty || isLoading
    }
    
    @MainActor
    func handleSignUp() async {
        isLoading = true
        do {
            try await AuthService.shared.createAccount(for: username, with: email, and: password)
        } catch {
            errorState.errorMessage = "Failed to create an account: \(error.localizedDescription)"
            errorState.showError = true
            isLoading = false
        }
    }
}
