import SwiftUI
import FacebookLogin

struct FacebookButton: UIViewRepresentable {

    func makeUIView(context: Context) -> UIButton { FBLoginButton.init() }

    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<FacebookButton>) { }
}
