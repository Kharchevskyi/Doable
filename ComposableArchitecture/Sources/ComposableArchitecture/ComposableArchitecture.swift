import SwiftUI
import Combine

public typealias Effect = () -> Void
public typealias Reducer<Value, Action> = (inout Value, Action) -> Effect

public final class Store<Value, Action>: ObservableObject {
    let reducer: Reducer<Value, Action>

    @Published public private(set) var value: Value

    private var cancelable: Cancellable?

    public init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
        self.value = initialValue
        self.reducer = reducer
    }

    public func send(_ action: Action) {
        let effect = reducer(&value, action)
        effect()
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
                return {}
            }
        )

        localStore.cancelable = self.$value.sink { [weak localStore] newValue in
            localStore?.value = toLocalView(newValue)
        }

        return localStore
    }
}

public func combine<Value, Action>(_ reducers: Reducer<Value, Action>...) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducers.map { $0(&value, action)}

        return {
            for effect in effects {
                effect()
            }
        }
    }
}

public func pullback<GlobalAction, LocalAction, GlobalValue, LocalValue>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return {} }
        let effect = reducer(&globalValue[keyPath: value], localAction)
        return effect
    }
}
