import SwiftUI
import ComposableArchitecture
import FacebookLogin
import FacebookCore

public enum SigningAction {
    case facebookLogIn
    case facebookLogOut
}

public struct SigningState {
    public var isLoggedIn: Bool

    public init(_ isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
}

public func signinReducer(state: inout SigningState, action: SigningAction) {
    switch action {
    case .facebookLogIn:
        state.isLoggedIn = true
    case .facebookLogOut:
        state.isLoggedIn = false
    }
}

public struct LoginView: View {
    @ObservedObject var store: Store<SigningState, SigningAction>
    @State var isButtonDisabled = false
    private var title: String {
        self.store.value.isLoggedIn ? "Log out" : "Log in"
    }

    private let manager = LoginManager.init()

    public init(store: Store<SigningState, SigningAction>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            //                FacebookButton()
            Button(self.title) {
                self.store.value.isLoggedIn
                    ? self.logout()
                    : self.login()
            }
            .disabled(isButtonDisabled)
        }
    }

    private func login() {
        self.isButtonDisabled = true
        manager.logIn(
            permissions: [.publicProfile],
            viewController: nil) { result in
                switch result {
                case .success: self.store.send(.facebookLogIn)
                default: self.store.send(.facebookLogOut)
                }
                self.isButtonDisabled = false
            }
    }

    private func logout() {
        manager.logOut()
        store.send(.facebookLogOut)
    }
}



struct FacebookButton: UIViewRepresentable {

    func makeUIView(context: Context) -> UIButton {
        FBLoginButton.init()
    }

    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<FacebookButton>) {

    }
}
