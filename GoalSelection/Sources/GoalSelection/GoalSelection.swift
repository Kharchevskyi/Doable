import SwiftUI
import ComposableArchitecture

public struct GoalSelectionState {
    public var goals: [String]

    public init(
        goals: [String]
    ) {
        self.goals = goals
    }
}

public enum GoalSelectionAction {
    case add
    case remove
}

public func goalSelectionReducer(state: inout GoalSelectionState, action: GoalSelectionAction) {
    switch action {
    case .add:
        state.goals.append("New goal \(state.goals.count)")
    case .remove:
        guard !state.goals.isEmpty else { return }
        state.goals.removeLast()
    }
}


public struct GoalSelectionView: View {
    @ObservedObject var store: Store<GoalSelectionState, GoalSelectionAction>

    public init(store: Store<GoalSelectionState, GoalSelectionAction>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            VStack {
                Button("Add") { self.store.send(.add) }
                Button("Remove") { self.store.send(.remove) }
                Text("Goals selected \(self.store.value.goals.count)")
            }
        }
        .navigationBarTitle("Select your Goal")
    }
}
