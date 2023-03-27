
import ComposableArchitecture
import Foundation

extension ArticleListItem: ReducerProtocol {
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}
