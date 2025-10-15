import SwiftUI

struct RootView: View {
    
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        switch viewModel.authState {
        case .pending:
            ProgressView()
                .controlSize(.large)
        case .loggedIn(let loggedInUser):
            MainTabView(loggedInUser)
        case .loggedOut:
            LoginView()
        }
    }
}
