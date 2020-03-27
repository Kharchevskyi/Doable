//
//  SceneDelegate.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 05/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import UIKit
import SwiftUI
import FacebookCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let contentView = InitialView.build()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let openURL = URLContexts.first else { return }
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: openURL.url,
            sourceApplication: openURL.options.sourceApplication,
            annotation: openURL.options.annotation
        )
    }
}
