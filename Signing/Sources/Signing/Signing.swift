import SwiftUI
import ComposableArchitecture
import FacebookLogin
import FacebookCore

// MARK: - Action
public enum LoginResponse {
    case loggedIn
    case loggedOut
    case cancelled
}

public enum SigningAction {
    case loginResponse(result: LoginResponse)
    case loginButtonTapped(LoginService)
}

// MARK: - State
public struct SigningState {
    public var isLoggedIn: Bool
    public var isLoggedInButtonDisabled: Bool

    public init(
        _ isLoggedIn: Bool,
        isLoggedInButtonDisabled: Bool
    ) {
        self.isLoggedIn = isLoggedIn
        self.isLoggedInButtonDisabled = isLoggedInButtonDisabled
    }
}

// MARK: - Reducer
public func signingReducer(state: inout SigningState, action: SigningAction) -> [Effect<SigningAction>]{
    switch action {
    case let .loginButtonTapped(service):
        state.isLoggedInButtonDisabled = true
        return [
            service.login()
                .map(SigningAction.loginResponse)
                .receive(on: .main)
        ]

    case let .loginResponse(result):
        state.isLoggedInButtonDisabled = false
        switch result {
        case .loggedIn: state.isLoggedIn = true
        case .loggedOut: state.isLoggedIn = false
        case .cancelled: break
        }
        return []
    }
}

// MARK: - LoginService
public protocol LoginService {
    func login() -> Effect<LoginResponse>
}


// MARK: - Facebook Extension
extension LoginManager: LoginService {
    public func login() -> Effect<LoginResponse> {
        Effect { callback in
            self.logIn(permissions: [.publicProfile], viewController: nil) { result in
                callback(result.response)
            }
        }
    }
}

extension LoginResult {
    public var response: LoginResponse {
        switch self {
        case .cancelled: return .cancelled
        case .failed: return .loggedOut
        case .success: return .loggedIn
        }
    }
}

// MARK: - LoginView
public struct LoginView: View {
    @ObservedObject var store: Store<SigningState, SigningAction>

    private var title: String {
        self.store.value.isLoggedIn ? "Log out" : "Log in"
    }

    private let manager = LoginManager.init()

    public init(store: Store<SigningState, SigningAction>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            Button(self.title) {
//                self.store.send(.loginButtonTapped(self.manager))
                self.store.send(.loginButtonTapped(MockedLoginManager()))
            }
            .disabled(self.store.value.isLoggedInButtonDisabled)
        }
    }
}

// MARK: - Mock
enum ErrorMock: Error {
    case some
}
struct MockedLoginManager: LoginService {
    func login() -> Effect<LoginResponse> {
        Effect { callback in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                callback(LoginResponse.loggedIn)
            }
        }
    }
}
