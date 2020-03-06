//
//  ContentView.swift
//  Doable
//
//  Created by Anton Kharchevskyi on 05/03/2020.
//  Copyright © 2020 Anton Kharchevskyi. All rights reserved.
//

import SwiftUI

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
            pullback(counterReducer, value: \.count),
            goalReducer
        )
        return ContentView(
            store: Store(
                initialValue: AppState(),
                reducer: appReducer
            )
        )
    }
}


enum CounterAction {
    case incrTap, decrTap
}

enum GoalAction {
    case save, remove
}

enum AppAction {
    case counter(CounterAction)
    case goal(GoalAction)
}


func counterReducer(state: inout Int, action: AppAction) {
    switch action {
    case .counter(.incrTap): state += 1
    case .counter(.decrTap): state -= 1
    default: break
    }
}

func goalReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .goal(.save): state.title = "Goal added"
    case .goal(.remove): state.title = "Goal replaced"
    default: break
    }
}

//
//func appReducer(value: inout AppState, action: AppAction) {
//    switch action {
//    case .counter(.incrTap): value.title = "Doable + 1"
//    case .counter(.decrTap): value.title = "Doable - 1"
//    case .goal(.save): value.title = "Goal added"
//    case .goal(.remove): value.title = "Goal replaced"
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView.build()
    }
}


func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        reducers.forEach { $0(&value, action) }
    }
}

func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping (inout LocalValue, Action) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>
) -> (inout GlobalValue, Action) -> Void {
    return { globalValue, action in
        reducer(&globalValue[keyPath: value], action)
    }
}
