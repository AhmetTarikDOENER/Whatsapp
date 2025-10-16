import Foundation
import Combine

final class RootViewModel: ObservableObject {
    
    @Published private(set) var authState = AuthState.pending
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = AuthService.shared.authState.receive(on: DispatchQueue.main)
            .sink { [weak self] latestAuthState in
                self?.authState = latestAuthState
            }
        
        AuthService.testAccounts.forEach { email in
            registerTestAccounts(with: email)
        }
    }
    
    /// Register Test Accounts to Backend
    private func registerTestAccounts(with email: String) {
        Task {
            let username = email.replacingOccurrences(of: "@gmail.com", with: "")
            try? await AuthService.shared.createAccount(for: username, with: email, and: "123456")
        }
    }
}
