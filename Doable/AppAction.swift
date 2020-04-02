//
//  AppAction.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 06/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import Foundation
import Signing
import GoalSelection
import GoalsList

enum AppAction {
    case goalSelection(GoalSelectionAction)
    case signing(SigningAction)
    case goalsList(GoalsListAction)

    var goalsList: GoalsListAction? {
        get {
            guard case let .goalsList(value) = self else { return nil }
            return value
        }
        set {
            guard case .goalsList = self, let newValue = newValue else { return }
            self = .goalsList(newValue)
        }
    }

    var goalSelection: GoalSelectionAction? {
        get {
            guard case let .goalSelection(value) = self else { return nil }
            return value
        }
        set {
            guard case .goalSelection = self, let newValue = newValue else { return }
            self = .goalSelection(newValue)
        }
    }

    var signing: SigningAction? {
        get {
            guard case let .signing(value) = self else { return nil }
            return value
        }
        set {
            guard case .signing = self, let newValue = newValue else { return }
            self = .signing(newValue)
        }
    }
}
