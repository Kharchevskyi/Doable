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
    var isLoggedIn = false
    var goals: [String] = []
}

extension AppState {
    var signingState: SigningState {
        get {
            SigningState(isLoggedIn)
        }
        set {
            self.isLoggedIn = newValue.isLoggedIn
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
