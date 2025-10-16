import Combine
import FirebaseAuth
import FirebaseDatabase

//  MARK: - Auth States
enum AuthState {
    case pending, loggedIn(User), loggedOut
}

enum AuthError: Error {
    case accountCreationFailed(_ description: String)
    case failedToSaveUserData(_ description: String)
    case emailLoginFailed(_ description: String)
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accountCreationFailed(let description): return description
        case .failedToSaveUserData(let description): return description
        case .emailLoginFailed(let description): return description
        }
    }
}

//  MARK: - Protocol
protocol AuthServiceProtocol {
    static var shared: AuthServiceProtocol { get }
    var authState: CurrentValueSubject<AuthState, Never> { get }
    
    func login(with email: String, and password: String) async throws
    func autoLogin() async
    func createAccount(for username: String, with email: String, and password: String) async throws
    func logout() async throws
}

//  MARK: - Service
final class AuthService: AuthServiceProtocol {
    
    //  MARK: - Property
    var authState = CurrentValueSubject<AuthState, Never>(.pending)
    
    //  MARK: - Init
    static let shared: AuthServiceProtocol = AuthService()
    private init() {
        Task { await autoLogin() }
    }
    
    //  MARK: - Internal
    func login(with email: String, and password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            fetchUserInfoFromDatabase()
            print("Successfully signed in \(authResult.user.email ?? "")")
        } catch {
            print("Failed to sign into the account with: \(email)")
            throw AuthError.emailLoginFailed(error.localizedDescription)
        }
    }
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            authState.send(.loggedOut)
        } else {
            fetchUserInfoFromDatabase()
        }
    }
    
    func createAccount(for username: String, with email: String, and password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            let newUser = User(uid: uid, username: username, email: email)
            try await saveUserInfoToDatabase(user: newUser)
            self.authState.send(.loggedIn(newUser))
        } catch {
            print("🔐 Failed to create an account\n: \(error.localizedDescription)")
            throw AuthError.accountCreationFailed(error.localizedDescription)
        }
    }
    
    func logout() async throws {
        do {
            try Auth.auth().signOut()
            authState.send(.loggedOut)
            print("Successfully logged out.")
        } catch {
            print("Failed to log out current user: \(error.localizedDescription)")
        }
    }
}

extension AuthService {
    private func saveUserInfoToDatabase(user: User) async throws {
        do {
            let userDictionary: [String: Any] = [.uid: user.uid, .username: user.username, .email: user.email]
            try await FirebaseConstants.UserReference.child(user.uid).setValue(userDictionary)
        } catch {
            print("🔐 Failed to save user data to database: \(error.localizedDescription)")
            throw AuthError.failedToSaveUserData(error.localizedDescription)
        }
    }
    
    private func fetchUserInfoFromDatabase() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.UserReference.child(currentUid).observe(.value) { [weak self] snapshot in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let loggedInUser = User(dictionary: userDictionary)
            self?.authState.send(.loggedIn(loggedInUser))
            print("\(loggedInUser.username) is logged in.")
        } withCancel: { error in
            print("Failed to get current user info")
        }
    }
}

//  MARK: - AuthService+TestAccounts
extension AuthService {
    static let testAccounts: [String] = [
        "testUser1@gmail.com",
        "testUser2@gmail.com",
        "testUser3@gmail.com",
        "testUser4@gmail.com",
        "testUser5@gmail.com",
        "testUser6@gmail.com",
        "testUser7@gmail.com",
        "testUser8@gmail.com",
        "testUser9@gmail.com",
        "testUser10@gmail.com",
        "testUser11@gmail.com",
        "testUser12@gmail.com",
        "testUser13@gmail.com",
        "testUser14@gmail.com",
        "testUser15@gmail.com",
        "testUser16@gmail.com",
        "testUser17@gmail.com",
        "testUser18@gmail.com",
        "testUser19@gmail.com",
        "testUser20@gmail.com",
        "testUser21@gmail.com",
        "testUser22@gmail.com",
        "testUser23@gmail.com",
        "testUser24@gmail.com",
        "testUser25@gmail.com",
        "testUser26@gmail.com",
        "testUser27@gmail.com",
        "testUser28@gmail.com",
        "testUser29@gmail.com",
        "testUser30@gmail.com",
        "testUser31@gmail.com",
        "testUser32@gmail.com",
        "testUser33@gmail.com",
        "testUser34@gmail.com",
        "testUser35@gmail.com",
        "testUser36@gmail.com",
        "testUser37@gmail.com",
        "testUser38@gmail.com",
        "testUser39@gmail.com",
        "testUser40@gmail.com",
        "testUser41@gmail.com",
        "testUser42@gmail.com",
        "testUser43@gmail.com",
        "testUser44@gmail.com",
        "testUser45@gmail.com",
        "testUser46@gmail.com",
        "testUser47@gmail.com",
        "testUser48@gmail.com",
        "testUser49@gmail.com",
        "testUser50@gmail.com"
    ]
}
