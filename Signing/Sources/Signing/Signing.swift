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

    var title: String {
        isLoggedIn
            ? "Log out"
            : "Log in"
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

    public init(store: Store<SigningState, SigningAction>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            //                FacebookButton()
            Button("\(String(self.store.value.isLoggedIn))") {
                self.store.value.isLoggedIn
                    ? self.store.send(.facebookLogOut)
                    : self.store.send(.facebookLogIn)
            }
        }
    }
}



struct FacebookButton: UIViewRepresentable {

    func makeUIView(context: Context) -> UIButton {
        return FBLoginButton.init()
    }

    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<FacebookButton>) {
        print("^^ \(uiView)")
    }
}

//final class CustomLoginButton: UIButton {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//}
