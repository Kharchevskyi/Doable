//
//  With.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 08/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import Foundation

/// Left-to-right function application.
/// Pipe forward operation `|>`
func with<A, B>(_ a: A, f: (A) throws -> B) rethrows -> B {
    try f(a)
}
