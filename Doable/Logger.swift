//
//  Logger.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 08/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import Foundation

func logging<Value, Action>(
    _ reducer: @escaping (inout Value, Action) -> Void
) -> (inout Value, Action) -> Void {
    return { value, action in
        reducer(&value, action)
        print("Action: \(action)")
        print("State:")
        dump(value)
        print("---")
    }
}
