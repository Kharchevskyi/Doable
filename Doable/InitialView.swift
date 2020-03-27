//
//  InitialView.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 10/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import Foundation

import SwiftUI
import ComposableArchitecture
import Signing

struct InitialView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    "Local view",
                    destination: LocalCountView(
                        store: store.view(
                            view:  { $0.count},
                            action: { .counter($0) }
                        )
                    )
                )
                NavigationLink(
                    "Content view",
                    destination: ContentView(
                        store: store
                    )
                )
                NavigationLink(
                    "Login view",
                    destination: LoginView(
                        store: store.view(
                            view: {
                                $0.signingState
                            },
                            action: { .signing($0) }
                        )
                    )
                )
                .navigationBarTitle("Initial View")
            }
        }
    }

    static func build() -> InitialView {
        let appReducer: (inout AppState, AppAction) -> Void = combine(
            pullback(counterReducer, value: \.count, action: \.counter),
            goalReducer,
            pullback(signinReducer, value: \.signingState, action: \.signing)
        )

        let reducer = with(appReducer, f: logging)

        return InitialView(
            store: Store(
                initialValue: AppState(),
                reducer: reducer
            )
        )
    }
}
