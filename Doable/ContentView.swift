//
//  ContentView.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 05/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            VStack {
                Button("+") { self.store.send(.counter(.incrTap)) }
                Button("-") { self.store.send(.counter(.decrTap)) }
                Button("Add") { self.store.send(.goal(.save)) }
                Button("Remove") { self.store.send(.goal(.remove)) }
                Text(store.value.title + "\(store.value.count)")
            }
            .navigationBarTitle("Title")
        }
    }

    static func build() -> ContentView {
        let appReducer = combine(
            pullback(counterReducer, value: \.count, action: \.counter),
            goalReducer
        )

        let reducer = with(appReducer, f: logging)
        return ContentView(
            store: Store(
                initialValue: AppState(),
                reducer: reducer
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView.build()
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

enum GoalAction {
    case save, remove
}

func goalReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .goal(.save): state.title = "Goal added"
    case .goal(.remove): state.title = "Goal replaced"
    default: break
    }
}
