import SwiftUI
import ComposableArchitecture

public enum GoalsListAction {
    case remove(IndexSet)
    case loadedGoals([String])
    case saveTapped
    case loadTapped
}

public func goalsListReducer(state: inout [String], action: GoalsListAction) -> [Effect<GoalsListAction>] {
    switch action {
    case let .remove(indexSet):
        state.remove(atOffsets: indexSet)
        return []
    case let .loadedGoals(goals):
        state = goals
        return []
    case .saveTapped:
        return [saveGoal(state)]
    case .loadTapped:
        return [loadGoals()]
    }
}

private func loadGoals() -> Effect<GoalsListAction> {
    {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentURL = URL(fileURLWithPath: documentPath)
        let goalsURL = documentURL.appendingPathComponent("goals.json")
        guard
            let data = try? Data(contentsOf: goalsURL),
            let goals = try? JSONDecoder().decode([String].self, from: data)
        else { return nil }

        return .loadedGoals(goals)
    }
}

private func saveGoal(_ state: [String]) -> Effect<GoalsListAction> {
    {
        let data = try! JSONEncoder().encode(state)
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentURL = URL(fileURLWithPath: documentPath)
        let goalsURL = documentURL.appendingPathComponent("goals.json")
        try! data.write(to: goalsURL)
        return nil
    }
}


public struct GoalsListView: View {
    @ObservedObject var store: Store<[String], GoalsListAction>

    public init(store: Store<[String], GoalsListAction>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(store.value, id: \.self) { goal in
                    Text(goal)
                }
                .onDelete(perform: delete)
            }
        }
        .navigationBarTitle("Your Goals")
        .navigationBarItems(trailing: navigationBarItems())
    }

    private func delete(at offsets: IndexSet) {
        self.store.send(.remove(offsets))
    }

    private func navigationBarItems() -> some View {
        HStack {
            Button("Save") { self.store.send(.saveTapped) }
            Button("Load") { self.store.send(.loadTapped) }
        }
    }
}
