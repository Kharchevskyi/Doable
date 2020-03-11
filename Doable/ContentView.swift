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
                Button("Add") { self.store.send(.goal(.save)) }
                Button("Remove") { self.store.send(.goal(.remove)) }
                Text(store.value.title + "\(store.value.count)")

            }
        }
        .navigationBarTitle("Content View")
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



//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(store: <#T##Store<AppState, AppAction>#>)
//    }
//}

