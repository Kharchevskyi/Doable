//
//  LocalCountView.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 10/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import SwiftUI
import ComposableArchitecture


struct LocalCountView: View {
    @ObservedObject var store: Store<Int, CounterAction>

    var body: some View {
        NavigationView {
            VStack {
                Button("+") { self.store.send(.incrTap) }
                Button("-") { self.store.send(.decrTap) }
            }
        }.navigationBarTitle("Title \(store.value)")
    }
}

enum CounterAction {
    case incrTap, decrTap
}

func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
    case .incrTap: state += 1
    case .decrTap: state -= 1
    }
}
