import SwiftUI
import Combine

public final class Store<Value, Action>: ObservableObject {
    let reducer: (inout Value, Action) -> Void
    @Published public private(set) var value: Value
    private var cancelable: Cancellable?


    public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.value = initialValue
        self.reducer = reducer
    }

    public func send(_ action: Action) {
        reducer(&value, action)
    }

    public func view<LocalValue, LocalAction>(
        view toLocalView: @escaping (Value) -> (LocalValue),
        action toGlobalAction: @escaping(LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalView(self.value),
            reducer: { localValue, localAction in
                self.send(toGlobalAction(localAction))
                localValue = toLocalView(self.value)
            }
        )

        localStore.cancelable = self.$value.sink { [weak localStore] newValue in
            localStore?.value = toLocalView(newValue)
        }

        return localStore
    }
}

public func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}

public func pullback<GlobalAction, LocalAction, GlobalValue, LocalValue>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&globalValue[keyPath: value], localAction)
    }
}
