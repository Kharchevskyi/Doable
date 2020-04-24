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
import GoalSelection
import GoalsList

struct InitialView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    "Goals List",
                    destination: GoalsListView(
                        store: store.view(
                            view:  { $0.goals },
                            action: { .goalsList($0) }
                        )
                    )
                )
                NavigationLink(
                    "Goal Selection",
                    destination: GoalSelectionView(
                        store: store.view(
                            view: { $0.goalSelectionState },
                            action: { .goalSelection($0) }
                        )
                    )
                )
                NavigationLink(
                    "Login view",
                    destination: LoginView(
                        store: store.view(
                            view: { $0.signingState },
                            action: { .signing($0) }
                        )
                    )
                )
                .navigationBarTitle("Initial View")
            }
        }
    }

    static func build() -> InitialView {
        let appReducer: Reducer<AppState, AppAction> = combine(
            pullback(goalSelectionReducer, value: \.goalSelectionState , action: \.goalSelection),
            pullback(signingReducer, value: \.signingState, action: \.signing),
            pullback(goalsListReducer, value: \.goals, action: \.goalsList)
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
