//
//  AppAction.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 06/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import Foundation
import Signing

enum AppAction {
    case counter(CounterAction)
    case goal(GoalAction)
    case signing(SigningAction)

    var counter: CounterAction? {
        get {
            guard case let .counter(value) = self else { return nil }
            return value
        }
        set {
            guard case .counter = self, let newValue = newValue else { return }
            self = .counter(newValue)
        }
    }

    var goal: GoalAction? {
        get {
            guard case let .goal(value) = self else { return nil }
            return value
        }
        set {
            guard case .goal = self, let newValue = newValue else { return }
            self = .goal(newValue)
        }
    }
}
