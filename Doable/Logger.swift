//
//  Logger.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 08/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import Foundation
import ComposableArchitecture

func logging<Value, Action>(_ reducer: @escaping Reducer<Value, Action>) -> Reducer<Value, Action> {
    { value, action in
        let effect = reducer(&value, action)
        let newValue = value
        return {
            print("Action: \(action)")
            print("State:")
            dump(newValue)
            print("---")
            effect()
        }
    }
}
