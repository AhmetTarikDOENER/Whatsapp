import Combine
import FirebaseAuth
import FirebaseDatabase

//  MARK: - Auth States
enum AuthState {
    case pending, loggedIn, loggedOut
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
    private init() {}
    
    //  MARK: - Internal
    func login(with email: String, and password: String) async throws {
        
    }
    
    func autoLogin() async {
        
    }
    
    func createAccount(for username: String, with email: String, and password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = authResult.user.uid
        let newUser = User(uid: uid, username: username, email: email)
        try await saveUserInfoToDatabase(user: newUser)
    }
    
    func logout() async throws {
        
    }
}

extension AuthService {
    private func saveUserInfoToDatabase(user: User) async throws {
        let userDictionary = ["uid": user.uid, "username": user.username, "email": user.email]
        try await Database.database().reference().child("users").child(user.uid).setValue(userDictionary)
    }
}
