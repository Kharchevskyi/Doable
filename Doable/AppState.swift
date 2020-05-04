//
//  AppState.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 05/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import Foundation
import GoalSelection
import Signing

struct AppState {
    var title = "Doable"
    var count = 0

    var goals: [String] = []

    var isLoggedIn = false
    var isLoggedInButtonDisabled = false
}

extension AppState {
    var signingState: SigningState {
        get {
            SigningState(isLoggedIn, isLoggedInButtonDisabled: isLoggedInButtonDisabled)
        }
        set {
            isLoggedIn = newValue.isLoggedIn
            isLoggedInButtonDisabled = newValue.isLoggedInButtonDisabled
        }
    }
}

extension AppState {
    var goalSelectionState: GoalSelectionState {
        get {
            GoalSelectionState(goals: goals)
        }
        set {
            self.goals = newValue.goals
        }
    }
}
